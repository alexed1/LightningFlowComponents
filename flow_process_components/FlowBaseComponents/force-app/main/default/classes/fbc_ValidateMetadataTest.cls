   @isTest 
   public with sharing class fbc_ValidateMetadataTest { 

   @isTest
   public static void validationRejectsIsChanged() {
        String flowMetadata = getMetadataString();
        String validationString = fbc_ValidateMetadata.validate(flowMetadata);
        
        System.assertNotEquals(null,validationString);
   }

 
    public static String getMetadataString() {
    return '<?xml version="1.0" encoding="UTF-8"?>' + 
 + '        <Flow xmlns="http://soap.sforce.com/2006/04/metadata">' + 
 + '            <actionCalls>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>postTarget</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>User User</stringValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '             <processMetadataValues>' + 
 + '                    <name>postTargetUserType</name>' + 
 + '                   <value>' + 
 + '                        <stringValue>USER</stringValue>' + 
 + '                    </value>' + 
+'               </processMetadataValues>' + 
+'               <processMetadataValues>' + 
+'                   <name>textJson</name>' + 
+'                   <value>' + 
+'                       <stringValue>{&quot;mentions&quot;:[],&quot;message&quot;:&quot;Name changed via Advanced checkbox&quot;}</stringValue>' + 
+'                   </value>' + 
+'               </processMetadataValues>' + 
+'               <name>myRule_1_A1</name>' + 
+'               <label>Post Update</label>' + 
+'               <locationX>100</locationX>' + 
+'               <locationY>200</locationY>' + 
+'               <actionName>chatterPost</actionName>' + 
+'               <actionType>chatterPost</actionType>' + 
+'               <inputParameters>' + 
+'                   <name>text</name>' + 
+'                   <value>' + 
+'                       <stringValue>Name changed via Advanced checkbox</stringValue>' + 
+'                   </value>' + 
+'               </inputParameters>' + 
+'               <inputParameters>' + 
+'                   <name>type</name>' + 
+'                   <value>' + 
+'                       <stringValue>USER</stringValue>' + 
+'                   </value>' + 
+'               </inputParameters>' + 
+'               <inputParameters>' + 
+'                   <name>subjectNameOrId</name>' + 
+'                   <value>' + 
+'                       <stringValue>0050t000005NoduAAC</stringValue>' + 
+'                   </value>' + 
+'               </inputParameters>' + 
+'           </actionCalls>' + 
+'           <actionCalls>' + 
+'               <processMetadataValues>' + 
+'                   <name>postTarget</name>' + 
+'                   <value>' + 
+'                       <stringValue>User User</stringValue>' + 
+'                   </value>' + 
+'               </processMetadataValues>' + 
+'               <processMetadataValues>' + 
+'                   <name>postTargetUserType</name>' + 
+'                   <value>' + 
+'                       <stringValue>USER</stringValue>' + 
+'                   </value>' + 
+'               </processMetadataValues>' + 
+'               <processMetadataValues>' + 
+'                   <name>textJson</name>' + 
+'                   <value>' + 
 + '                        <stringValue>{&quot;mentions&quot;:[],&quot;message&quot;:&quot;Rating changed via Is Changed operator&quot;}</stringValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <name>myRule_3_A1</name>' + 
 + '                <label>Post Update 2</label>' + 
 + '                <locationX>300</locationX>' + 
 + '                <locationY>200</locationY>' + 
 + '                <actionName>chatterPost</actionName>' + 
 + '                <actionType>chatterPost</actionType>' + 
 + '                <inputParameters>' + 
 + '                    <name>text</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>Rating changed via Is Changed operator</stringValue>' + 
 + '                    </value>' + 
 + '                </inputParameters>' + 
 + '                <inputParameters>' + 
 + '                    <name>type</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>USER</stringValue>' + 
 + '                    </value>' + 
 + '                </inputParameters>' + 
 + '                <inputParameters>' + 
 + '                    <name>subjectNameOrId</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>0050t000005NoduAAC</stringValue>' + 
 + '                    </value>' + 
 + '                </inputParameters>' + 
 + '            </actionCalls>' + 
 + '            <actionCalls>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>postTarget</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>User User</stringValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>postTargetUserType</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>USER</stringValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>textJson</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>{&quot;mentions&quot;:[],&quot;message&quot;:&quot;Industry changed via formula&quot;}</stringValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <name>myRule_6_A1</name>' + 
 + '                <label>Post Update 3</label>' + 
 + '                <locationX>600</locationX>' + 
 + '                <locationY>200</locationY>' + 
 + '                <actionName>chatterPost</actionName>' + 
 + '                <actionType>chatterPost</actionType>' + 
 + '                <inputParameters>' + 
 + '                    <name>text</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>Industry changed via formula</stringValue>' + 
 + '                    </value>' + 
 + '                </inputParameters>' + 
 + '                <inputParameters>' + 
 + '                    <name>type</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>USER</stringValue>' + 
 + '                    </value>' + 
 + '                </inputParameters>' + 
 + '                <inputParameters>' + 
 + '                    <name>subjectNameOrId</name>' + 
 + '                    <value>' + 
 + '                        <stringValue>0050t000005NoduAAC</stringValue>' + 
 + '                    </value>' + 
 + '                </inputParameters>' + 
 + '            </actionCalls>' + 
 + '            <decisions>' + 
 + '                <name>isChangedDecision4_myRule_3_Rating</name>' + 
 + '                <label>isChangedDecision4_myRule_3_Rating</label>' + 
 + '                <locationX>0</locationX>' + 
 + '                <locationY>0</locationY>' + 
 + '                <defaultConnector>' + 
 + '                    <targetReference>myDecision</targetReference>' + 
 + '                </defaultConnector>' + 
 + '                <defaultConnectorLabel>default</defaultConnectorLabel>' + 
 + '                <rules>' + 
 + '                    <name>isChangedRule_4_myRule_3_Rating</name>' + 
 + '                    <conditionLogic>and</conditionLogic>' + 
 + '                    <conditions>' + 
 + '                        <leftValueReference>myVariable_old</leftValueReference>' + 
 + '                        <operator>IsNull</operator>' + 
 + '                        <rightValue>' + 
 + '                            <booleanValue>false</booleanValue>' + 
 + '                        </rightValue>' + 
 + '                    </conditions>' + 
 + '                    <conditions>' + 
 + '                        <leftValueReference>myVariable_old.Rating</leftValueReference>' + 
 + '                        <operator>NotEqualTo</operator>' + 
 + '                        <rightValue>' + 
 + '                            <elementReference>myVariable_current.Rating</elementReference>' + 
 + '                        </rightValue>' + 
 + '                    </conditions>' + 
 + '                    <connector>' + 
 + '                        <targetReference>myDecision</targetReference>' + 
 + '                    </connector>' + 
 + '                    <label>isChangedRule_4_myRule_3_Rating</label>' + 
 + '                </rules>' + 
 + '            </decisions>' + 
 + '            <decisions>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>index</name>' + 
 + '                    <value>' + 
 + '                        <numberValue>0.0</numberValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <name>myDecision</name>' + 
 + '                <label>myDecision</label>' + 
 + '                <locationX>50</locationX>' + 
 + '                <locationY>0</locationY>' + 
 + '                <defaultConnector>' + 
 + '                    <targetReference>myDecision2</targetReference>' + 
 + '                </defaultConnector>' + 
 + '                <defaultConnectorLabel>default</defaultConnectorLabel>' + 
 + '                <rules>' + 
 + '                    <name>myRule_1</name>' + 
 + '                    <conditionLogic>and</conditionLogic>' + 
 + '                    <conditions>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>inputDataType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>leftHandSideType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>operatorDataType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>rightHandSideType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <leftValueReference>myVariable_current.Name</leftValueReference>' + 
 + '                        <operator>EqualTo</operator>' + 
 + '                        <rightValue>' + 
 + '                            <stringValue>foo</stringValue>' + 
 + '                        </rightValue>' + 
 + '                    </conditions>' + 
 + '                    <connector>' + 
 + '                        <targetReference>myRule_1_pmetdec</targetReference>' + 
 + '                    </connector>' + 
 + '                    <label>If Name has Changed via Advanced</label>' + 
 + '                </rules>' + 
 + '            </decisions>' + 
 + '            <decisions>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>index</name>' + 
 + '                    <value>' + 
 + '                        <numberValue>1.0</numberValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <name>myDecision2</name>' + 
 + '                <label>myDecision2</label>' + 
 + '                <locationX>50</locationX>' + 
 + '                <locationY>0</locationY>' + 
 + '                <defaultConnector>' + 
 + '                    <targetReference>myDecision5</targetReference>' + 
 + '                </defaultConnector>' + 
 + '                <defaultConnectorLabel>default</defaultConnectorLabel>' + 
 + '                <rules>' + 
 + '                    <name>myRule_3</name>' + 
 + '                    <conditionLogic>and</conditionLogic>' + 
 + '                    <conditions>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>inputDataType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>Boolean</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>leftHandSideType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>Picklist</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>operatorDataType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>rightHandSideType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>Boolean</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <leftValueReference>isChangedRule_4_myRule_3_Rating</leftValueReference>' + 
 + '                        <operator>EqualTo</operator>' + 
 + '                        <rightValue>' + 
 + '                            <booleanValue>true</booleanValue>' + 
 + '                        </rightValue>' + 
 + '                    </conditions>' + 
 + '                    <connector>' + 
 + '                        <targetReference>myRule_3_A1</targetReference>' + 
 + '                    </connector>' + 
 + '                    <label>If Rating has changed via is changed operator</label>' + 
 + '                </rules>' + 
 + '            </decisions>' + 
 + '            <decisions>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>index</name>' + 
 + '                    <value>' + 
 + '                        <numberValue>2.0</numberValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <name>myDecision5</name>' + 
 + '                <label>myDecision5</label>' + 
 + '                <locationX>50</locationX>' + 
 + '                <locationY>0</locationY>' + 
 + '                <defaultConnectorLabel>default</defaultConnectorLabel>' + 
 + '                <rules>' + 
 + '                    <name>myRule_6</name>' + 
 + '                    <conditionLogic>and</conditionLogic>' + 
 + '                    <conditions>' + 
 + '                        <leftValueReference>formula_myRule_6</leftValueReference>' + 
 + '                        <operator>EqualTo</operator>' + 
 + '                        <rightValue>' + 
 + '                            <booleanValue>true</booleanValue>' + 
 + '                        </rightValue>' + 
 + '                    </conditions>' + 
 + '                    <connector>' + 
 + '                        <targetReference>myRule_6_A1</targetReference>' + 
 + '                    </connector>' + 
 + '                    <label>If Industry has changed via formula ischanged</label>' + 
 + '                </rules>' + 
 + '            </decisions>' + 
 + '            <decisions>' + 
 + '                <name>myRule_1_pmetdec</name>' + 
 + '                <label>Previously Met Decision</label>' + 
 + '                <locationX>100</locationX>' + 
 + '                <locationY>100</locationY>' + 
 + '                <defaultConnector>' + 
 + '                    <targetReference>myRule_1_A1</targetReference>' + 
 + '                </defaultConnector>' + 
 + '                <defaultConnectorLabel>Not Previously Met</defaultConnectorLabel>' + 
 + '                <rules>' + 
 + '                    <name>myRule_1_pmetnullrule</name>' + 
 + '                    <conditionLogic>or</conditionLogic>' + 
 + '                    <conditions>' + 
 + '                        <leftValueReference>myVariable_old</leftValueReference>' + 
 + '                        <operator>IsNull</operator>' + 
 + '                        <rightValue>' + 
 + '                            <booleanValue>true</booleanValue>' + 
 + '                        </rightValue>' + 
 + '                    </conditions>' + 
 + '                    <connector>' + 
 + '                        <targetReference>myRule_1_A1</targetReference>' + 
 + '                    </connector>' + 
 + '                    <label>Previously Met - Null</label>' + 
 + '                </rules>' + 
 + '                <rules>' + 
 + '                    <name>myRule_1_pmetrule</name>' + 
 + '                    <conditionLogic>and</conditionLogic>' + 
 + '                    <conditions>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>inputDataType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>leftHandSideType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>operatorDataType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <processMetadataValues>' + 
 + '                            <name>rightHandSideType</name>' + 
 + '                            <value>' + 
 + '                                <stringValue>String</stringValue>' + 
 + '                            </value>' + 
 + '                        </processMetadataValues>' + 
 + '                        <leftValueReference>myVariable_old.Name</leftValueReference>' + 
 + '                        <operator>EqualTo</operator>' + 
 + '                        <rightValue>' + 
 + '                            <stringValue>foo</stringValue>' + 
 + '                        </rightValue>' + 
 + '                    </conditions>' + 
 + '                    <label>Previously Met - Prev</label>' + 
 + '                </rules>' + 
 + '            </decisions>' + 
 + '            <formulas>' + 
 + '                <processMetadataValues>' + 
 + '                    <name>originalFormula</name>' + 
 + '                    <value>' + 
 + '                        <stringValue> ISCHANGED([Account].Industry ) </stringValue>' + 
 + '                    </value>' + 
 + '                </processMetadataValues>' + 
 + '                <name>formula_myRule_6</name>' + 
 + '                <dataType>Boolean</dataType>' + 
 + '                <expression> ISCHANGED({!myVariable_current.Industry} )</expression>' + 
 + '            </formulas>' + 
 + '            <interviewLabel>Changeorama_Process-1_InterviewLabel</interviewLabel>' + 
 + '            <label>Changeorama Process</label>' + 
 + '            <processMetadataValues>' + 
 + '                <name>ObjectType</name>' + 
 + '                <value>' + 
 + '                    <stringValue>Account</stringValue>' + 
 + '                </value>' + 
 + '            </processMetadataValues>' + 
 + '            <processMetadataValues>' + 
 + '                <name>ObjectVariable</name>' + 
 + '                <value>' + 
 + '                    <elementReference>myVariable_current</elementReference>' + 
 + '                </value>' + 
 + '            </processMetadataValues>' + 
 + '            <processMetadataValues>' + 
 + '                <name>OldObjectVariable</name>' + 
 + '                <value>' + 
 + '                    <elementReference>myVariable_old</elementReference>' + 
 + '                </value>' + 
 + '            </processMetadataValues>' + 
 + '            <processMetadataValues>' + 
 + '                <name>TriggerType</name>' + 
 + '                <value>' + 
 + '                    <stringValue>onAllChanges</stringValue>' + 
 + '                </value>' + 
 + '            </processMetadataValues>' + 
 + '            <processType>Workflow</processType>' + 
 + '            <startElementReference>isChangedDecision4_myRule_3_Rating</startElementReference>' + 
 + '            <status>Active</status>' + 
 + '            <variables>' + 
 + '                <name>myVariable_current</name>' + 
 + '                <dataType>SObject</dataType>' + 
 + '                <isCollection>false</isCollection>' + 
 + '                <isInput>true</isInput>' + 
 + '                <isOutput>true</isOutput>' + 
 + '                <objectType>Account</objectType>' + 
 + '            </variables>' + 
 + '            <variables>' + 
 + '                <name>myVariable_old</name>' + 
 + '                <dataType>SObject</dataType>' + 
 + '                <isCollection>false</isCollection>' + 
 + '                <isInput>true</isInput>' + 
 + '                <isOutput>false</isOutput>' + 
 + '                <objectType>Account</objectType>' + 
 + '            </variables>' + 
 + '        </Flow>';
       

    }
   }