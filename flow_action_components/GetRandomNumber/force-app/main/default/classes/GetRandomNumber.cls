global with sharing class GetRandomNumber {
    
    @InvocableMethod
    global static List<Results> getRandomNumberFromRange(List<Requests> requests)
       {
           
            Results curResult = new Results();
            curResult.randomNumber = generateRandomFromRange(requests[0].startNumber, requests[0].endNumber);
           
            List<Results> resultsList = new List<results>();
            resultsList.add(curResult);
            return resultsList;
       }
  
    
    
    global static Double generateRandomFromRange(Integer startNum, Integer endNum) {
        
        
        if(startNum == 0 && endNum == 1)
            return Math.random();
        
        Integer returnValue;
        //Logic- first we will generate random boolean value which will decide if we want to
        //add the random number from startNum or will subtract random number from endNum
        Integer randomNumber = Integer.valueof((math.random() * 10));
        boolean addSubFlag= math.mod(randomNumber,2) == 0 ? true : false;
        
        integer diffInRange = endNum-startNum;
        //Now find random number staring from 0 to diffInRange
        Integer randomNum = Math.mod(Math.round(Math.random()*diffInRange+1),diffInRange);
        
        //If addSubFlag is true, we will add random number generated between 0 and diffInRange from start number
        //else we will subtract random number from end number
                if(addSubFlag){
            if(diffInRange > 1)
                returnValue =startNum + randomNum;
            else
                returnValue =startNum;
        }else{
            if(diffInRange > 1)
                returnValue = endNum - randomNum;
            else
                returnValue =endNum;
        }
        return returnValue;
        
    }
    
    global class Requests {
        @InvocableVariable(required=true)
    	global Integer startNumber;
        
        @InvocableVariable(required=true)
    	global Integer endNumber;
    }
    
    global class Results {
        @InvocableVariable
    	global Double randomNumber;
    }
}
