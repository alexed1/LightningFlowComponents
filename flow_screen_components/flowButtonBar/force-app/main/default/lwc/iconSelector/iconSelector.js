import { LightningElement, api, track } from 'lwc';

const ICON_NAMES = {
    STANDARD: 'account,action-list-component,actions-and-buttons,activations,address,agent-session,all,announcement,answer-best,answer-private,answer-public,apex,apex-plugin,app,approval,apps,apps-admin,article,asset-action,asset-action-source,asset-downtime-period,asset-object,asset-relationship,asset-state-period,assigned-resource,assignment,avatar,avatar-loading,bot,bot-training,branch-merge,brand,business-hours,buyer-account,buyer-group,calibration,call,call-coaching,call-history,campaign,campaign-members,cancel-checkout,canvas,carousel,case,case-change-status,case-comment,case-email,case-log-a-call,case-milestone,case-transcript,case-wrap-up,catalog,category,channel-program-history,channel-program-levels,channel-program-members,channel-programs,chart,choice,client,cms,coaching,code-playground,collection-variable,connected-apps,constant,contact,contact-list,contact-request,contract,contract-line-item,currency,currency-input,custom,custom-notification,customer_lifecycle_analytics,customer_portal_users,customer-360,customers,dashboard,dashboard_ea,data_integration_hub,data_model,data_streams,datadotcom,dataset,date_input,date_time,decision,default,delegated_account,display_rich_text,display_text,document,drafts,dynamic_record_choice,education,einstein_replies,email,email_chatter,employee,employee_asset,employee_contact,employee_job,employee_job_position,employee_organization,empty,endorsement,entitlement,entitlement_policy,entitlement_process,entitlement_template,entity,entity_milestone,environment_hub,event,events,expense,expense_report,expense_report_entry,feed,feedback,file,filter,first_non_empty,flow,folder,forecasts,formula,fulfillment_order,generic_loading,global_constant,goals,group_loading,groups,hierarchy,high_velocity_sales,home,household,individual,insights,instore_locations,investment_account,invocable_action,iot_context,iot_orchestrations,javascript_button,job_family,job_position,job_profile,kanban,knowledge,lead,lead_insights,lead_list,letterhead,lightning_component,lightning_usage,link,list_email,live_chat,live_chat_visitor,location,log_a_call,logging,loop,macros,maintenance_asset,maintenance_plan,marketing_actions,merge,messaging_conversation,messaging_session,messaging_user,metrics,multi_picklist,multi_select_checkbox,news,note,number_input,omni_supervisor,operating_hours,opportunity,opportunity_contact_role,opportunity_splits,order_item,orders,outcome,output,partner_fund_allocation,partner_fund_claim,partner_fund_request,partner_marketing_budget,partners,password,past_chat,people,performance,person_account,photo,picklist_choice,picklist_type,planogram,poll,portal,portal_roles,portal_roles_and_subordinates,post,pricebook,process,product,product_consumed,product_item,product_item_transaction,product_request,product_request_line_item,product_required,product_transfer,proposition,question_best,question_feed,queue,quick_text,quip,quip_sheet,quotes,radio_button,read_receipts,recent,record,record_create,record_delete,record_lookup,record_update,recycle_bin,related_list,relationship,reply_text,report,resource_absence,resource_capacity,resource_preference,resource_skill,return_order,return_order_line_item,reward,rtc_presence,sales_cadence,sales_cadence_target,sales_channel,sales_path,sales_value,salesforce_cms,scan_card,schedule_objective,scheduling_constraints,scheduling_policy,screen,search,segments,service_appointment,service_appointment_capacity_usage,service_contract,service_crew,service_crew_member,service_report,service_resource,service_territory,service_territory_location,service_territory_member,settings,shift,shift_preferences,shift_template,shift_type,shipment,skill,skill_entity,skill_requirement,sms,snippet,snippets,sobject,sobject_collection,social,solution,sort,sossession,stage,stage_collection,steps,store,store_group,story,strategy,survey,system_and_global_variable,task,task2,team_member,template,text,text_template,textarea,textbox,thanks,thanks_loading,timesheet,timesheet_entry,timeslot,today,topic,topic2,trailhead,unmatched,user,user_role,variable,visit_templates,visits,visualforce_page,voice_call,waits,webcart,work_capacity_limit,work_capacity_usage,work_contract,work_order,work_order_item,work_plan,work_plan_rule,work_plan_template,work_plan_template_entry,work_queue,work_step,work_step_template,work_type,work_type_group',
    UTILITY: 'activity,ad_set,add,adduser,advanced_function,advertising,agent_session,alert,all,anchor,animal_and_nature,announcement,answer,answered_twice,apex_plugin,apex,approval,apps,archive,arrowdown,arrowup,assignment,attach,automate,away,back,ban,block_visitor,bold,bookmark,breadcrumbs,broadcast,brush,bucket,builder,button_choice,call,campaign,cancel_file_request,cancel_transfer,capslock,cart,case,cases,center_align_text,change_owner,change_record_type,chart,chat,check,checkin,chevrondown,chevronleft,chevronright,chevronup,choice,classic_interface,clear,clock,close,collapse_all,collection_variable,color_swatch,comments,company,component_customization,connected_apps,constant,contact_request,contract_alt,contract,copy_to_clipboard,copy,crossfilter,currency_input,currency,custom_apps,cut,dash,database,datadotcom,date_input,date_time,dayview,delete,deprecate,description,desktop_and_phone,desktop_console,desktop,dialing,diamond,dislike,display_rich_text,display_text,dock_panel,down,download,drag_and_drop,drag,dynamic_record_choice,edit_form,edit,education,einstein,email_open,email,emoji,end_call,end_chat,end_messaging_session,engage,enter,erect_window,error,event,events,expand_all,expand_alt,expand,fallback,favorite,feed,file,filter,filterList,flow_alt,flow,food_and_drink,formula,forward_up,forward,frozen,fulfillment_order,full_width_view,global_constant,graph,groups,help_center,help,hide_mobile,hide,hierarchy,high_velocity_sales,home,identity,image,in_app_assistant,inbox,incoming_call,info_alt,info,insert_tag_field,insert_template,inspector_panel,internal_share,italic,jump_to_bottom,jump_to_top,justify_text,kanban,keyboard_dismiss,knowledge_base,layers,layout,leave_conference,left_align_text,left,level_down,level_up,light_bulb,lightning_extension,lightning_inspector,like,link,linked,list,listen,live_message,location,lock,locker_service_api_viewer,locker_service_console,log_a_call,logout,loop,lower_flag,macros,magicwand,mark_all_as_read,matrix,merge_field,merge,metrics,minimize_window,missed_call,money,moneybag,monthlyview,move,multi_picklist,multi_select_checkbox,muted,new_direct_message,new_window,new,news,note,notebook,notification,number_input,office365,offline_cached,offline,omni_channel,open_folder,open,opened_folder,outbound_call,outcome,overflow,package_org_beta,package_org,package,page,palette,password,paste,pause,people,phone_landscape,phone_portrait,photo,picklist_choice,picklist_type,picklist,pin,pinned,play,podcast_webinar,pop_in,power,preview,print,priority,privately_shared,process,prompt_edit,prompt,push,puzzle,question_mark,question,questions_and_answers,quick_text,quip,quotation_marks,quote,radio_button,rating,reassign,record_create,record_delete,record_lookup,record_update,record,recurring_exception,recycle_bin_empty,recycle_bin_full,redo,refresh,relate,reminder,remove_formatting,remove_link,replace,reply_all,reply,report_issue,reset_password,resource_absence,resource_capacity,resource_territory,retail_execution,retweet,ribbon,richtextbulletedlist,richtextindent,richtextnumberedlist,richtextoutdent,right_align_text,right,rotate,routing_offline,rows,rules,salesforce1,save,screen,search,section,send,sentiment_negative,sentiment_neutral,settings,setup_assistant_guide,setup_modal,setup,share_file,share_mobile,share_post,share,shield,shift_ui,shopping_bag,shortcuts,side_list,signpost,skip_back,skip_forward,skip,slider,smiley_and_people,sms,snippet,sobject_collection,sobject,socialshare,sort,spinner,stage_collection,stage,standard_objects,steps,stop,store,strategy,strikethrough,success,summary,summarydetail,survey,switch,symbols,sync,system_and_global_variable,table_settings,table,tablet_landscape,tablet_portrait,tabset,target,task,text_background_color,text_color,text_template,text,textarea,textbox,threedots_vertical,threedots,thunder,tile_card_list,toggle_panel_bottom,toggle_panel_left,toggle_panel_right,toggle_panel_top,toggle,topic,topic2,touch_action,tracker,trail,trailhead,travel_and_places,trending,turn_off_notifications,type_tool,type,undelete,undeprecate,underline,undo,unlinked,unlock,unmuted,up,upload,user_role,user,variable,video,voicemail_drop,volume_high,volume_low,volume_off,waits,warning,watchlist,weeklyview,wifi,work_order_type,world,yubi_key,zoomin,zoomout'
}

const NUM_CUSTOM_ICONS = 113; // as of 5/4/2021, update as needed
const CLASSES = {
    OPEN: 'slds-is-open'
}

const SEARCHBOX_ICONS = {
    CLEAR: 'utility:clear',
    SEARCH: 'utility:search'
}

const DEFAULT_MAX_RESULTS = 50;

export default class IconSelector extends LightningElement {

    @api excludeStandardIcons;
    @api excludeUtilityIcons;
    @api excludeCustomIcons;

    @api label = 'Select Icon';

    @api
    get value() {
        return this._value || null;
    }
    set value(value) {
        this._value = value;
        if (!this.rendered) {
            return;
        }
        if (value) {            
            this.addClass('input', 'slds-combobox__input-value');
            this.switchClass('.slds-combobox__form-element', 'slds-input-has-icon_right', 'slds-input-has-icon_left-right');
            this.addClass('.slds-combobox_container', 'slds-has-selection');
            this.template.querySelector('input').setAttribute('readonly', '');
            this.template.querySelector('input').value = value;
            this.blurSearchbox();
        } else {
            this.removeClass('input', 'slds-combobox__input-value');
            this.switchClass('.slds-combobox__form-element', 'slds-input-has-icon_left-right', 'slds-input-has-icon_right');            
            this.removeClass('.slds-combobox_container', 'slds-has-selection');
            this.template.querySelector('input').removeAttribute('readonly');
            this.template.querySelector('input').value = null;
        }
        this.dispatchEvent(new CustomEvent('selecticon', { detail: value }));
    }
    _value;


    @track icons = [];

    @api maxResults;
    currentMaxResults = this.maxResults;
    searchText;
    noMatchesFoundString = 'No matches found';
    blockBlur;
    rendered;

    /* GETTERS */
    get displayedIcons() {  
        return this.filteredIcons.slice(0, this.currentMaxResults);
    }

    get filteredIcons() {
        if (!this.searchText) {
            return this.icons;
        }      
        let icons = [];
        for (let icon of this.icons) {
            if (!this.searchText || icon.name.toLowerCase().includes(this.searchText)) {
                icons.push(icon);
            }
        }
        return icons;
    }

    get resultsExceedMax() {
        //console.log(this.filteredIcons.length, this.currentMaxResults, this.filteredIcons.length > this.currentMaxResults);
        return this.filteredIcons.length > this.currentMaxResults;
    }

    get loadMoreString() {
        return 'Load more ('+ this.currentMaxResults +' of '+ this.filteredIcons.length +' '+ (this.searchText ? 'matches' : 'options') +' displayed)';
    }

    get searchboxIcon() {
        return (this.searchText || this.value) ? SEARCHBOX_ICONS.CLEAR : SEARCHBOX_ICONS.SEARCH;
    }

    get searchbox() {
        return this.template.querySelector('inbox');
    }

    connectedCallback() {
        let standardIconNames = ICON_NAMES.STANDARD.split(',');
        let utilityIconNames = ICON_NAMES.UTILITY.split(',');

        if (!this.excludeStandardIcons) {
            for (let iconName of standardIconNames) {
                let safeName = iconName.replace(/-/g, '_'); // replaces any spaces with underscores
                this.icons.push({ name: 'standard:' + safeName });                
            }
        }

        if (!this.excludeUtilityIcons) {
            for (let iconName of utilityIconNames) {
                let safeName = iconName.replace(/-/g, '_'); // replaces any spaces with underscores
                this.icons.push({ name: 'utility:' + safeName });
            }
        }
        if (!this.excludeCustomIcons) {            
            for (let i = 1; i <= NUM_CUSTOM_ICONS; i++) {
                this.icons.push({ name: 'custom:custom' + i });
            }
        }

        if (!this.maxResults) { this.maxResults = DEFAULT_MAX_RESULTS; }
        if (!this.currentMaxResults) { this.currentMaxResults = this.maxResults; }

        //console.log(JSON.stringify(this.icons));
    }

    renderedCallback() {
        if (this.rendered) return;
        this.rendered = true;

        if (this.value)
            this.value = this.value;
    }

    /* ACTION FUNCTIONS */
    doSearch(searchText) {
        this.searchText = searchText ? searchText.toLowerCase() : null;
        this.showList();
    }

    showList() {
        this.addClass('.slds-dropdown-trigger', CLASSES.OPEN);
        this.focusSearchbox();
    }

    hideList() {
        this.removeClass('.slds-dropdown-trigger', CLASSES.OPEN);
    }

    loadMore() {
        this.currentMaxResults += this.maxResults;
    }

    focusSearchbox() {
        this.template.querySelector('input').focus();
    }

    blurSearchbox() {
        this.template.querySelector('input').blur();
    }

    clearSearchbox() {
        this.value = null;
        this.blockBlur = true;
        this.doSearch();
    }


    /* EVENT HANDLERS */
    handleIconSelect(event) {
        let icon = event.currentTarget.dataset.icon;
        this.value = icon;        
    }

    handleSearchFocus(event) {
        if (!this.value)
            this.doSearch(event.currentTarget.value);
    }

    handleSearchChange(event) {        
        this.doSearch(event.currentTarget.value);
    }    

    handleSearchBlur() {
        if (this.blockBlur) {            
            this.focusSearchbox();
            this.blockBlur = false;
        } else {
            this.currentMaxResults = this.maxResults;
            this.hideList();
        }
    }

    handleDropdownClick() {
        this.blockBlur = true;
    }

    handleSearchboxIconClick(event) {
        //if (this.value || this.searchText) {
            console.log('in searchboxicon click '+ event.currentTarget.iconName);
        if (event.currentTarget.iconName == SEARCHBOX_ICONS.CLEAR) {
            this.clearSearchbox();
        } else {
            this.doSearch();
        }
    }

    /* UTITLITY FUNCTIONS */
    addClass(selector, className) {
        let el = this.template.querySelector(selector);
        if (el)
            this.template.querySelector(selector).classList.add(className);
        return !!el;
    }

    removeClass(selector, className) {
        let el = this.template.querySelector(selector);
        if (el)
            this.template.querySelector(selector).classList.remove(className);
        return !!el;
    }

    switchClass(selector, removeClass, addClass) {
        this.removeClass(selector, removeClass);
        this.addClass(selector, addClass);
    }
}