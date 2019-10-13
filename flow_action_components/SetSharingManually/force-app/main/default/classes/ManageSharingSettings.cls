global with sharing class ManageSharingSettings implements RoleManagerProvider {

    static String BUTTON_REMOVE = 'None';
    static String BUTTON_READ = 'Read';
    static String BUTTON_READ_WRITE = 'Read/Write';

    static List<RoleManagerController.ButtonSetting> supportedButtonSettings;
    static Map<String, String> BUTTON_TO_ACCESS_TYPE = new Map<String, String>{
            BUTTON_READ => 'Read', BUTTON_READ_WRITE => 'Edit'
    };

    public static String execute(String buttonName, String paramsString) {

        Map<String, String> params = (Map<String, String>) JSON.deserialize(paramsString, Map<String, String>.class);

        if (buttonName == BUTTON_READ || buttonName == BUTTON_READ_WRITE) {
            return add(
                    params.get('userOrGroupID'),
                    params.get('recordId'),
                    BUTTON_TO_ACCESS_TYPE.get(buttonName));
        } else if (buttonName == BUTTON_REMOVE) {
            return remove(
                    params.get('userOrGroupID'),
                    params.get('recordId'));
        }

        throw new AuraHandledException('Button "' + buttonName + '" is not supported');
    }


    private static String add(Id userOrGroupID, Id recordId, String level) {
        System.debug('entering upsertPerm');
        Schema.DescribeSObjectResult describe = getSharingDescribe(recordId);
        level = String.escapeSingleQuotes(level);

        if (!canIEditPerms(recordId)) {
            throw new AuraHandledException(Label.OwnerAdminModify);
        }
        System.debug('doing perm upsert');

        // special handling for role => groups
        if (UserOrGroupID.getSobjectType() == Schema.UserRole.SObjectType) {
            //it's a role...find the matching group?
            list<group> matchingGroups = [select id, name, type from group where RelatedId = :UserOrGroupID and type = 'Role'];
            if (matchingGroups.size() > 1) {
                throw new AuraHandledException(Label.MultipleGroupsForRole);
            } else if (matchingGroups.size() == 0) {
                throw new AuraHandledException(Label.RoleDoesNotHaveGroup);
            }
            UserOrGroupID = matchingGroups[0].Id;
        }
        String query = buildQuery(recordId);
        query = query + ' and UserOrGroupID =\'' + String.escapeSingleQuotes(String.valueOf(UserOrGroupID)) + '\'';
        System.debug(query);

        list<sObject> existing = database.query(query);
        String sobj = AdminTools.objectTypeFromId(recordId);

        if (existing.size() > 0) {
            System.debug('already existing. will update');
            //can I update this thing?

            if (!describe.isUpdateable() ||
                    !describe.fields.getMap().get(AdminTools.getAccessLevelField(sobj)).getDescribe().isUpdateable()
                    ) {
                throw new AuraHandledException(Label.OwnerAdminModify);
            }

            existing[0].put(AdminTools.getAccessLevelField(sobj), level);

            try {
                update existing;
            } catch (exception e) {
                throw new AuraHandledException(generateErrorMessage(e));
            }

            return JSON.serialize(existing);
        } else {
            System.debug('not already existing. will create');
            //are we even allowed to insert this?  for these specific fields that we'll set?
            if (!describe.isCreateable() ||
                    !describe.fields.getMap().get(AdminTools.getAccessLevelField(sobj)).getDescribe().isCreateable() ||
                    !describe.fields.getMap().get(AdminTools.getLookupField(sobj)).getDescribe().isCreateable() ||
                    !describe.fields.getMap().get('UserOrGroupId').getDescribe().isCreateable()
                    ) {
                throw new AuraHandledException(Label.OwnerAdminModify);
            }
            //create a new SObject dynamically and insert
            Schema.SObjectType newObj = Schema.getGlobalDescribe().get(getSharingTableName(sobj));
            sobject share = newObj.newSObject();

            share.put(AdminTools.getAccessLevelField(sobj), level);
            share.put(AdminTools.getLookupField(sobj), recordId);
            share.put('UserOrGroupId', String.escapeSingleQuotes(String.valueOf(UserOrGroupID)));

            if (AdminTools.objectTypeFromId(recordId) == 'Account') {
                //share.put('ContactAccessLevel', level);
                share.put('CaseAccessLevel', level);
                share.put('OpportunityAccessLevel', level);
            }
            try {
                insert share;
            } catch (exception e) {
                throw new AuraHandledException(generateErrorMessage(e));
            }
            return JSON.serialize(share);
        }
    }

    private static String remove(Id userOrGroupID, Id recordId) {

        //access check
        Schema.DescribeSObjectResult describe = getSharingDescribe(recordId);

        //can I delete the sharing objects?
        if (!describe.isDeletable() || !describe.isAccessible()) {
            throw new AuraHandledException(Label.LackingPermissions);
        }

        // special handling for role => groups
        if (UserOrGroupID.getSobjectType() == Schema.UserRole.SObjectType) {
            //it's a role...find the matching group?
            list<group> matchingGroups = [select id, name, type from group where RelatedId = :UserOrGroupID and type = 'Role'];
            if (matchingGroups.size() > 1) {
                throw new AuraHandledException(Label.MultipleGroupsForRole);
            }
            UserOrGroupID = matchingGroups[0].Id;
        }

        String query = buildQuery(recordId);
        query = query + ' and UserOrGroupID =\'' + String.escapeSingleQuotes(UserOrGroupID) + '\'';
        System.debug(query);

        list<sObject> existing = database.query(query);
        System.debug(existing);
        try {
            delete existing;
            return 'SUCCESS';//TODO: fix
        } catch (Exception ex) {
            throw new AuraHandledException(generateErrorMessage(ex));
        }
    }

    public static List<RoleManagerController.MemberInfo> getExisting(String recordId) {
        return getAllObjectShares(recordId);
    }

    private static List<RoleManagerController.MemberInfo> getAllObjectShares(String recordId) {
        if (!sharingExists(AdminTools.objectTypeFromId(recordId))) {
            throw new AuraHandledException(Label.OWDReadWrite);
        }
        List<RoleManagerController.MemberInfo> results = new List<RoleManagerController.MemberInfo>();
        list<sObject> shares = database.query(buildQuery(recordId));
        Map<Id, String> idToObjectType = new Map<Id, String>();

        for (sObject share : shares) {
            Id curRecId = (Id) share.get('UserOrGroupId');
            idToObjectType.put(curRecId, AdminTools.objectTypeFromId(curRecId));
        }

        Map<String, SObject> recordData = getRecordData(idToObjectType);

        for (sObject app : shares) {
            SObject shareObject = recordData.get((Id) app.get('UserOrGroupId'));
            String shareRecordName = (String) shareObject.get('Name');
            String shareRecordId = (String) shareObject.get('Id');
            results.add(new RoleManagerController.MemberInfo(
                    (Id) app.get('Id'),
                    (Id) shareRecordId,
                    shareRecordName,
                    shareRecordName + ' (' + idToObjectType.get((Id) app.get('UserOrGroupId')) + ')',
                    app)
            );
        }
        return results;
    }

    static Map<String, SObject> getRecordData(Map<Id, String> idToObjectType) {
        Set<Id> recordIds = idToObjectType.keySet();
        Map<String, List<Id>> typeToRecordIds = new Map<String, List<Id>>();
        Map<String, SObject> recordIdToRecord = new Map<String, SObject>();
        for (Id curId : recordIds) {
            String objectName = AdminTools.objectTypeFromId(curId);
            if (!typeToRecordIds.containsKey(objectName)) {
                typeToRecordIds.put(objectName, new List<String>());
            }
            typeToRecordIds.get(objectName).add(curId);
        }
        for (String curType : typeToRecordIds.keySet()) {
            list<SObject> shares = database.query('SELECT Id, Name' + getTypeSpecificFields(curType) + ' FROM ' + curType + ' WHERE Id IN: recordIds');
            Map<Id, Id> roleToRelatedGroupIds = new Map<Id, Id>();
            for (SObject share : shares) {
                if (curType == 'Group') {
                    String shareType = (String) share.get('Type');
                    if (shareType != 'Regular') {
                        idToObjectType.put((Id) share.get('Id'), shareType);
                    }
                    if (shareType == 'Role') {
                        roleToRelatedGroupIds.put((Id) share.get('RelatedId'), (Id) share.get('Id'));
                    } else{
                        recordIdToRecord.put((String) share.get('Id'), share);
                    }
                } else {
                    recordIdToRecord.put((String) share.get('Id'), share);
                }
            }
            //Some groups are representing roles
            if (!roleToRelatedGroupIds.isEmpty()) {
                List<UserRole> relatedRoles = [SELECT Id, Name FROM UserRole WHERE Id IN :roleToRelatedGroupIds.keySet()];
                if (!relatedRoles.isEmpty()) {
                    for (UserRole ur : relatedRoles) {
                        recordIdToRecord.put(roleToRelatedGroupIds.get(ur.Id), ur);
                    }
                }
            }
        }

        return recordIdToRecord;
    }

    static String getTypeSpecificFields(String sObjectType) {
        if (sObjectType == 'Group') {
            return ', RelatedId, Type';
        }
        return '';
    }

    private static void generateButtonSettings(String recordId) {
        String accessLevelFieldName;
        try {
            accessLevelFieldName = AdminTools.getAccessLevelField(AdminTools.objectTypeFromId(recordId));
        } catch (Exception ex) {
            AuraHandledException e = new AuraHandledException(Label.InvalidRecordIdMessage);
            e.setMessage(Label.InvalidRecordIdMessage);
            throw e;
        }

        supportedButtonSettings = new List<RoleManagerController.ButtonSetting>();

        supportedButtonSettings.add(new RoleManagerController.ButtonSetting(BUTTON_REMOVE, new RoleManagerController.ButtonMatchingRule(RoleManagerController.MatchingAction.NOTEXISTS)));

//        supportedButtonSettings.add(new RoleManagerController.ButtonSetting(
//                BUTTON_REMOVE,
//                new RoleManagerController.ButtonMatchingRule(RoleManagerController.MatchingAction.VALUEEQUALS, new Map<String, List<String>>{
//                        'RowCause' => (new List<String>{
//                                'Owner', 'ImplicitChild', 'ImplicitParent'
//                        })
//                })
//        ));

        supportedButtonSettings.add(new RoleManagerController.ButtonSetting(
                BUTTON_READ_WRITE,
                new RoleManagerController.ButtonMatchingRule(RoleManagerController.MatchingAction.VALUEEQUALS, new Map<String, List<String>>{
                        accessLevelFieldName => (new List<String>{
                                'Edit', 'All'
                        }),
                        'RowCause' => (new List<String>{
                                'Owner'
                        })
                })
        ));

        supportedButtonSettings.add(new RoleManagerController.ButtonSetting(
                BUTTON_READ,
                new RoleManagerController.ButtonMatchingRule(RoleManagerController.MatchingAction.VALUEEQUALS, new Map<String, List<String>>{
//                        'RowCause' => (new List<String>{
//                                'Owner'
//                        }),
                        accessLevelFieldName => (new List<String>{
                                'Read'
                        })
                }
                )));
    }

    public static List<RoleManagerController.ButtonSetting> getSupportedButtons(String recordId) {
        if (supportedButtonSettings == null) {
            generateButtonSettings(recordId);
        }
        return supportedButtonSettings;
    }


    @TestVisible
    private static String getSharingTableName(String sobj) {
        if (sobj.contains('__c')) {
            return sobj.replace('__c', '__Share');
        } else {
            return sobj + 'Share';
        }
    }

    @TestVisible
    private static boolean sharingExists(String sobj) {
        //custom objects
        if (sobj.contains('__c')) {
            Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
            if (tokens.containsKey(getSharingTableName(sobj).toLowerCase()) || tokens.containsKey('ltngsharing__' + getSharingTableName(sobj).toLowerCase())) {
                return true;
            }
        } else {
            String tableName = getSharingTableName(sobj);
            String query = 'select count() from ' + tableName;
            try {
                integer count = database.countQuery(query);
                if (count > 0) {
                    return true;
                } else {
                    return false;
                }
            } catch (exception e) {
                System.debug(e);
            }
            return false;
        }

        return false;
    }

    @TestVisible
    private static schema.DescribeSObjectResult getSharingDescribe(Id recordId) {
        try {
            String sharingName = getSharingTableName(AdminTools.objectTypeFromId(recordId));
            System.debug('sharingName in getSharingDescribe is: ' + sharingName);
            schema.DescribeSObjectResult curResult = Schema.getGlobalDescribe().get(sharingName).getDescribe();
            System.debug('global describe in getSharingDescribe is: ' + curResult);
            return curResult;
        } catch (exception e) {
            //probably means they don't have sharing turned on for this object
            throw new AuraHandledException(Label.OWDReadWrite);
        }
    }

    @TestVisible private static String buildQuery(Id recordId) {
        String sobj = AdminTools.objectTypeFromId(recordId);

        schema.DescribeSObjectResult describe = getSharingDescribe (recordId);

        if (!describe.isAccessible() ||
                !describe.fields.getMap().get('Id').getDescribe().isAccessible() ||
                !describe.fields.getMap().get('RowCause').getDescribe().isAccessible() ||
                !describe.fields.getMap().get('UserOrGroupId').getDescribe().isAccessible() ||
                !describe.fields.getMap().get(AdminTools.getAccessLevelField(sobj)).getDescribe().isAccessible() ||
                !describe.fields.getMap().get(AdminTools.getLookupField(sobj)).getDescribe().isAccessible()
                ) {
            throw new AuraHandledException(Label.LackingPermissions);
        }

        String query = 'select Id, RowCause, UserOrGroupId, ' + AdminTools.getAccessLevelField(sobj) + ' from ' + getSharingTableName(sobj) + ' where ' + AdminTools.getLookupField(sobj) + ' = \'' + String.escapeSingleQuotes(String.valueOf(recordId)) + '\'';
        System.debug(query);
        return query;
    }

    @AuraEnabled
    global static boolean canIEditPerms(Id recordId) {
        try {
            String query = 'SELECT RecordId, HasDeleteAccess, HasAllAccess FROM UserRecordAccess WHERE RecordId = \'' + String.escapeSingleQuotes(String.valueOf(recordId)) + '\' AND UserId = \'' + UserInfo.getUserId() + '\'';
            sObject o = Database.query(query);
            if ((Boolean) o.get('HasDeleteAccess') || (Boolean) o.get('HasAllAccess')) {
                System.Debug('edit allowed because user has full acesss or modify all permissions');
                return true;
            }
        } catch (System.queryException e) {
            //it's possible you can't even see that record and the queries are null!
            return false;
        }
        return false;
    }

    private static String generateErrorMessage(Exception ex) {
        if (ex.getMessage().contains('DELETE_FAILED') || ex.getMessage().contains('INVALID_ACCESS_LEVEL')) {
            return Label.CantReduceSharingLevelMessage;
        } else if (ex.getMessage().contains('FIELD_INTEGRITY_EXCEPTION')) {
            return Label.CannotBeSharedMessage;
        } else {
            return ex.getMessage();
        }
    }

}