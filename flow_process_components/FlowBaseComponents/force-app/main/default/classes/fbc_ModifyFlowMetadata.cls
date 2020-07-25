public with sharing class fbc_ModifyFlowMetadata {

    public static String SOAP_NS = 'http://soap.sforce.com/2006/04/metadata';
   
    public static Dom.XmlNode changeProcessType(Dom.XmlNode flowXML, String newProcesstype) {
        
        Dom.XmlNode curNode = flowXML.getChildElement('processType',  SOAP_NS);
        
        System.debug('processType is: ' + curNode.getText());
        curNode = fbc_XmlUtils.changeTextValue(newProcessType, curNode);
        //curNode = flowXML.getChildElement('processType',  SOAP_NS);         
        //System.debug('processType is now : ' + curNode.getText());
        return flowXML;
    }

    public static Dom.XmlNode setStatus(Dom.XmlNode flowXML, String newStatus) {
        
        Dom.XmlNode curNode = flowXML.getChildElement('status',  SOAP_NS);
        
        System.debug('status is: ' + curNode.getText());
        curNode = fbc_XmlUtils.changeTextValue(newStatus, curNode);
        //curNode = flowXML.getChildElement('processType',  SOAP_NS);         
        //System.debug('processType is now : ' + curNode.getText());
        return flowXML;
    }

    public static void deleteSelf(Dom.XmlNode curNode) {
        curNode.getParent().removeChild(curNode);
    }

   /*  Given a set of nodes like this:
    <processMetadataValues>
        <name>OldObjectVariable</name>
        <value>
            <elementReference>myVariable_old</elementReference>
        </value>
    </processMetadataValues> 
    you would delete this node by passing in targetNodeElementName of processMetadataValues and targetNodeNameValue of OldObjectVariable
    the node must have a name element */
    public static void deleteNode(List<Dom.XmlNode> curNodes, String targetNodeElementName, String targetNodeNameValue ) {
        List<Dom.XmlNode> candidateNodes = new List<Dom.XmlNode>();
        for ( Dom.XmlNode curNode : curNodes) {
            if(curNode.getName() == targetNodeElementName){
                candidateNodes.add(curNode);
            }
        }
        for (Dom.XmlNode curNode : candidateNodes) {
            if (curNode.getChildElement('name', SOAP_NS).getText() == targetNodeNameValue)
                deleteSelf(curNode);
        }


    }

    public static List<Dom.XmlNode> getChildrenByName(Dom.XmlNode flowXML, String targetName) {
        List<Dom.XmlNode> matchingNodes = new List<Dom.XmlNode>();
        List<Dom.XmlNode> allNodes = flowXML.getChildren();
        for (Dom.XmlNode curNode : allNodes) {
            if (curNode.getName() == targetName)
                matchingNodes.add(curNode);
        }
        return matchingNodes;
    } 
   
    public static void removeExcessPMV(Dom.XmlNode flowXML, String pmvName) {
        deleteNode(flowXML.getChildren(), 'processMetadataValues', pmvName);
    
    }

    public static void repositionElements(Dom.Document doc) {
        //get Decision elements that have order values into a group

        //get first decision element and verify that it has index 0
      
        Dom.XmlNode flowXml = doc.getRootElement();
        List<Dom.XmlNode> curDecisionNodes =  getChildrenByName(flowXML,'decisions');
        //System.debug('curDecisionNodes is: ' + curDecisionNodes);
        String curIndexVal = '0.0';
        //it appears to be safe to assume that the first decision node returned is always the first node in pb. we can verify by looking for index
        Dom.XmlNode curDecisionNode = curDecisionNodes[0];
        //verify index  
        Dom.XmlNode indexNode = fbc_XmlUtils.getChildProcessMetadataValueByName(curDecisionNode, 'index');
        String retrievedIndexVal = fbc_XmlUtils.getProcessMetadataValue(indexNode);
        System.debug ('indexNode is ' + retrievedIndexVal);
        System.debug ('targetindexval is ' + curIndexVal);
        if (retrievedIndexVal != curIndexVal)
            throw new PBConvertException('expected a different index value of the current decision node:' + curDecisionNode);
         // set its Y Pos to 300 + order*100
        //System.debug('beforexypos, state is: ' + doc.toXmlString());
        setXYPosition(curDecisionNode, '43', '300');
       // System.debug('afterxypos, state is: ' + doc.toXmlString());
        Boolean finished = false;
        Integer yPosition = 300;
        while(finished != true) {
            repositionActions(doc, curDecisionNode, String.valueOf(yPosition));
            yPosition = yPosition + 200;
            Dom.XmlNode defaultConnectorElement = curDecisionNode.getChildElement('defaultConnector', SOAP_NS);
            if (defaultConnectorElement != null ) {
                String nextDefaultNodeName = defaultConnectorElement.getChildElement('targetReference', SOAP_NS).getText();
                if (nextDefaultNodeName != null) {
                    for (Dom.XmlNode nextDecisionCandidate : curDecisionNodes ) {
                        if (nextDecisionCandidate.getChildElement('name', SOAP_NS).getText() == nextDefaultNodeName) {
                            setXYPosition(nextDecisionCandidate, '43', String.valueOf(yPosition) );
                            System.debug ('setting position of: ' + nextDefaultNodeName + 'to a Y position of: ' + yPosition);
                            curDecisionNode = nextDecisionCandidate;
                        }
                    }
                } else throw new PBConvertException('something went wrong. found a default connector in a decision element but didnt find a name value inside');
                
            } else {
                finished = true;
            }
            
            
        }

    }

    public static String getTargetReference(Dom.XmlNode curNode) {
        Dom.XmlNode nodeConnectorElement = curNode.getChildElement('connector', SOAP_NS);
        if (nodeConnectorElement != null ) {
            String nodeConnectorTargetReferenceElementText = nodeConnectorElement.getChildElement('targetReference', SOAP_NS).getText();
            if (nodeConnectorTargetReferenceElementText != null) {
                return nodeConnectorTargetReferenceElementText;
            }

        }
        System.debug('failed to find next node name for this node: ' + fbc_XmlUtils.getInternalName(curNode));
        return null;
    }



    //finds the targetReference value
    public static String findNextNodeName(Dom.XmlNode curNode) {
        System.debug('finding next node name forthis node: ' + fbc_XmlUtils.getInternalName(curNode));
        //if the curNode name is decisions do rules than connnector, else just connector 
         
        if (curNode.getName() == 'decisions'){
            Dom.XmlNode nodeRulesElement = curNode.getChildElement('rules', SOAP_NS);
            if (nodeRulesElement != null ) {
               return getTargetReference(nodeRulesElement);
            }
            System.debug('failed to find next node name for this node: ' + fbc_XmlUtils.getInternalName(curNode));
        } else {
            return getTargetReference(curNode);
        }
        return null;

    }

    public static void repositionActions(Dom.Document doc, Dom.XmlNode coreDecisionNode, String currentYPos) {
        System.debug('entering repositionActions');
        Dom.XmlNode flowXml = doc.getRootElement();
        Integer xPosition = 400;
        String nextNodeName= findNextNodeName(coreDecisionNode);
        while (nextNodeName != null && !nextNodeName.contains('decision')) {
            System.debug ('nextNodeName is: ' + nextNodeName);
            //find child of flowxml that has a child name element equal to this  generalize getChildProcessMetadataValueByName
            Dom.XmlNode targetNode = fbc_XmlUtils.getChildNodeByInternalName(flowXML, nextNodeName);
            setXYPosition(targetNode,String.valueOf(xPosition), currentYPos);
            xPosition = xPosition + 150;
            //look in the node for another connector. if you find one, set nextNodeName equal to the new value, else set nextNodeName to null
            nextNodeName = findNextNodeName(targetNode);
        } 

    }

    public static void setXYPosition(Dom.XmlNode curNode, String newXVal, String newYVal) {
        System.debug('changing the position of this node: ' + fbc_XmlUtils.getInternalName(curNode) + ' to xval ' + newXVal + ' and to yval ' + newYVal);
        Dom.XmlNode curXPos = curNode.getChildElement('locationX', SOAP_NS);
        Dom.XmlNode curYPos = curNode.getChildElement('locationY', SOAP_NS);
        if (curXPos == null || curYPos == null)
            throw new PBConvertException('tried to set the x or y position on an xml node that does not support position values');
        deleteSelf(curXPos);
        curNode.addChildElement('locationX', SOAP_NS, null).addTextNode(newXVal);
        deleteSelf(curYPos);
        curNode.addChildElement('locationY', SOAP_NS, null).addTextNode(newYVal);

    }

   

    //delete the variable myVariable_current
    //change all existing myVariable_current references to $Record
    public static Dom.Document changeContextReference(Dom.Document doc) {
        
        Dom.XMLNode flowXML = doc.getRootElement();

        List<Dom.XmlNode> allNodes = flowXML.getChildren();
        deleteNode(allNodes, 'variables', 'myVariable_current');
        
        //find and replace
         String metadataString = doc.toXmlString();
        metadataString = metadataString.replace('myVariable_current', '$Record');
        //System.debug('metadatastring is: ' + metadataString);
        Dom.Document convertedDoc = new Dom.Document();
        convertedDoc.load(metadataString);   
        return convertedDoc; 

    }

    public static Dom.Document fixupRelatedReferences(Dom.Document doc) {
        
        //find and replace
        String metadataString = doc.toXmlString();
        metadataString = metadataString.replace('Owner.Id', 'OwnerId');
        metadataString = metadataString.replace('User.Id', 'UserId');
        Dom.Document convertedDoc = new Dom.Document();
        convertedDoc.load(metadataString);
        return convertedDoc;
        
    }

    public static Dom.XmlNode addStartElement(Dom.XmlNode flowXML, String contextObjectType, String triggerType, String startElementReference) {
        DOM.Document doc = new DOM.Document();
        //String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        //dom.XmlNode startHolder = doc.createRootElement('startHolder', SOAP_NS, '');
        System.debug('startElementReference is: ' + startElementReference);
        Dom.XmlNode oldStartReference = flowXML.getChildElement('startElementReference', SOAP_NS);
        flowXML.removeChild(oldStartReference);
        Dom.XmlNode startNode = flowXML.addChildElement('start', SOAP_NS, null);
        
        startNode.addChildElement('locationX', SOAP_NS, null).addTextNode('43');
        startNode.addChildElement('locationY', SOAP_NS, null).addTextNode('43');
        startNode.addChildElement('connector', SOAP_NS, null).addChildElement('targetReference', SOAP_NS, null).addTextNode(startElementReference);
        startNode.addChildElement('object', SOAP_NS, null).addTextNode(contextObjectType);
        startNode.addChildElement('recordTriggerType', SOAP_NS, null).addTextNode('Create');
        startNode.addChildElement('triggerType', SOAP_NS, null).addTextNode('RecordAfterSave');
        


        //System.debug ('flowxml with start is: ' + flowXML);
        
        return flowXML;
    }

    public class PBConvertException extends Exception{}

}

