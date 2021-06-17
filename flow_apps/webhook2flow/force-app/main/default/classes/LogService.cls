/**
 * @description : Log details to custom SObject (ie API activity, errors in Aync processes, etc...)
 * 
 *   for simple one liners to add log to queue use static LogService.add{ANY}() methods;  
 *   for tracking the lifecycle of a given proccess in a single log record use Log() constructors, then use properties/append as needed then finally addLog() 
 * 		this is useful for callouts, long processes, tracking duration, multiple messages, etc..
 
 * 
 * 	use save to commit the logs in the queue;
 *	use immediateSave if you want to save the queue using an immediate platformEvent 
 		- causes no DML so can be invoked prior / between callouts
		- will save log regardless if current apex process completes succesfully (committed)


 * @author            : Tom Snyder <tom@3ddd.com>
 * @group             : 
 * @last modified on  : 05-18-2021
 * @last modified by  : Jack D. Pond
 * Modifications LogService 
 * Ver   Date         Author                      Modification
 * 1.0   2020-11-06   Tom Snyder <tom@3ddd.com>   Initial Version
 * 
 * 
 * TODO: make logtype, severity as enum
 * 
**/
public with sharing class LogService {
	
	//properties

	private LogService__c record {get;  set;}

	//collection of log records
	@TestVisible private static LIST<LogService__c> queue = new LIST<LogService__c>();

	//quick access getter/setters
	public string logType { get { return record.type__c; } set { record.type__c=value; }}
	public string message { get { return record.Message__c; } set { record.Message__c=value; }}
	public string source { get { return record.source__c; } set { record.source__c=value; }}
	public string severity { get { return record.severity__c; } set { record.severity__c=value; }}
	public string host { get { return record.host__c; } set { record.host__c = (value!=null) ? value.replace('callout:','') : null; }}
	public string request { get { return record.Request__c; } set { record.Request__c=value; }}
	public string response { get { return record.Response__c; } set { record.Response__c=value; }}
	public boolean hasErrors { get { return !String.isBlank(record.ErrorMessage__c); } }

	//constructors
	public LogService(){
		record=new LogService__c();
		startTimer();
	}
	public LogService(string source, string msg) {		
		LogService__c l= new LogService__c(type__c='Message', source__c=source, Message__c=msg);
		record=l;
		startTimer();
	}

	/*
	public Log(string source, object obj) {		
		LogService__c l= new LogService__c(type__c='Message', source__c=source, Message__c=JSON.serialize(obj));
		record=l;
		startTimer();
	}
	*/

	public LogService(string source, HttpRequest req) { this(source,httpRequest2RestRequest(req),'HTTP_Callout'); }
	public LogService(string source, System.RestRequest req) { this(source,req, 'HTTP_Callin'); }
	public LogService(string source, System.RestRequest req, string typ) { 
		this.record = new LogService__c(Type__c = typ, Source__c = source);
		this.append(req);
		startTimer();
	}


	public dateTime timerStart {get; private set;}
    public void startTimer() {
        this.timerStart=dateTime.now();
    }


	//append... is used for updating to open (current) log;  useful when a log record.
	public void append(Exception ex) { append(ex, 'ERROR'); }
	public void append(Exception ex, string severity)  {
        if (ex!=null) {

			/* TODO
			if (ex instanceof System.DmlException) {
				System.DmlException dmlEx = (System.DmlException) ex;
				string msg = String.format('{0} DML DmlExceptions',new string[]{ string.valueOf(dmlEx.getNumDml())});
				for(integer i=0; i<dmlEx.getNumDml(); i++) {
					...
				}
			} */
			if (this.source==null)	
				this.source = String.isBlank(ex.getStackTraceString()) ? 'Exception:'+ string.valueOf(ex).left(244) :  ex.getStackTraceString().substringBefore(':');

			string errMsg = String.format('{0}\nType: {1}\nStack: {2}\nCause:{3}',new string[]{ ex.getMessage(), ex.getTypeName(), ex.getStackTraceString(), ex.getCause()?.getMessage() });
			if (this.record.ErrorMessage__c!=null) {
				//append error
				errMsg='\n\n'+ errMsg;
            	this.record.ErrorMessage__c+=errMsg;
			}
			else {
				this.record.ErrorMessage__c=errMsg;
			}
			this.severity= (severity==null) ? 'ERROR' : severity;
        }
	}


	public void append(HttpRequest req) {
		append(httpRequest2RestRequest(req));
	}
	public void append(System.RestRequest req) {
		if (req!=null) {
			string hostHeader = req.headers.get('Host'); 
			this.record.Host__c = (hostHeader!=null) ? hostHeader : req.requestURI?.replace('callout:','').replace('https://','').replace('http://','').substringBefore('/')?.toLowercase();
            this.record.HttpMethod__c = req.httpMethod;
            this.record.RequestURI__c = req.requestURI;
            this.record.Request__c = req.requestBody?.toString();
            this.record.RequestHeaders__c = String.valueOf(req.headers);
        }
	}
	public void append(HttpResponse resp) {
		append(httpResponse2RestResponse(resp));
	}
	public void append(System.RestResponse resp) {
        if (resp!=null) {
            this.record.StatusCode__c = resp.statusCode;
			this.record.ResponseHeaders__c = String.valueOf(resp.headers);
            this.record.Response__c = resp.responseBody?.toString();
        }
	}

	/*
	public void append(HttpRequest req, HttpResponse resp) {
		append(httpRequest2RestRequest(req), httpResponse2RestResponse(resp));
	}
	public void append(System.RestRequest req, System.RestResponse resp) {
		append(req);
		append(resp);
	}
	*/

	public void appendMessage(string msg) {
		if (this.record.Message__c!=null) {
			msg='\n\n'+ msg;
		}
		this.record.Message__c+=msg;
		this.severity='ERROR';
	}



	//add... create and push log to the queue;
	public static void addMessage(string source, string msg) {  addMessage(source,msg,null); }
	public static void addMessage(string source, string msg, string severity) {
		LogService__c l= new LogService__c(type__c='Message', source__c=source, message__c=msg, severity__c = severity);
		addLog(l);
	}
	
	public static void addException(Exception ex) {	addException(ex, null); }
	public static void addException(Exception ex, string severity) { addException(null, ex, severity); }
	public static void addException(string source, Exception ex, string severity) {
		LogService l = new LogService();
		l.logType = 'Exception';
		l.source = source;
		l.append(ex, severity);
		addLog(l);
	}

	public static void addLog(LogService l) {
		if (l.timerStart!=null) {
            l.record.CallDuration__c = datetime.now().getTime() - l.timerStart.getTime();
            l.timerStart=null;
        }
		addLog(l.record);
	}
	
	public static void addLog(LogService__c l) {
		//truncate as needed
		Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.allowFieldTruncation = true;
		l.setOptions(dmo);
		queue.add(l);
	}
	

	public static void immediateSave() {
		if (queue.size()>0) {
			LogServiceEvent__e[] evnts = new LogServiceEvent__e[]{};
			//string jsonLog = JSON.serialize(queue);
			//evnts.add(new GeneralImmediateEvent__e(Type__c='Add', body__c=jsonLog));
			for (LogService__c l : queue) {
				string jsonLog = JSON.serialize(new LIST<LogService__c>{l});
				evnts.add(new LogServiceEvent__e(Type__c='AddLog', body__c=jsonLog));
			}
			EventBus.publish(evnts);
			queue.clear();
		}
	}
	

	public static void save() {
		if (queue.size()>0) {
			LIST<Database.Saveresult> irs = database.insert(queue, false);
			integer ordinal = 0;
			for (Database.Saveresult ir : irs) {
				if (ir.success) {
					queue.remove(ordinal);
				}
				else {
					ordinal++;
//					system.debug(ir);
				}
			}
		}	
	}


	//Helpers
	
    private static System.RestRequest httpRequest2RestRequest(HttpRequest request) {
        System.RestRequest restRequest = new System.RestRequest();
        if(request!=null) {
            restRequest.requestBody = request.getBodyAsBlob();
            restRequest.httpMethod = request.getMethod();
            restRequest.requestURI = request.getEndpoint();
			//request.getHeader(key)
        }
        return restRequest;
    }

    private static System.RestResponse httpResponse2RestResponse(HttpResponse resp) {
        System.RestResponse restResp = new System.RestResponse();
        if(resp!=null) {
            restResp.statusCode = resp.getStatusCode();
            restResp.responseBody = resp.getBodyAsBlob();
			for (string k : resp.getHeaderKeys()) { try { restResp.headers.put(k, resp.getHeader(k)); }catch(Exception ex){} }
        }
        return restResp;
    }


	public class LogException extends Exception {}
}