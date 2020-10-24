//
//Copyright (c) 2015 Pedro Dal Col, Pliny Smith
//
global class Zippex 
{    
    private Map<String, FileObject> zipFileMap = new Map<String, FileObject>{};
    protected String zipFileString = '';  // stores the Hex version of the file blob
    
    // Zippex constructor
    // Instantiates a new empty Zippex object (empty Zip archive).
    global Zippex(){}
   
    // Zippex UnZipping Constructor
    // Instantiates a new Zippex object from an existing Zip archive passed as a Blob
    global Zippex(Blob fileData)
    {
        zipFileString = EncodingUtil.convertToHex(fileData);
        Integer offsetOfEndCentralDirSignature = zipFileString.lastIndexOf(endCentralDirSignature);
        
        Integer numberOfFiles = HexUtil.hexToIntLE(zipFileString.mid(offsetOfEndCentralDirSignature+10*2, 2*2));    //offset 10, 2 bytes
        
        offsetOfStartOfCentralDir = zipFileString.mid(offsetOfEndCentralDirSignature+16*2, 4*2); // 4 bytes
        
        Integer offset = HexUtil.hexToIntLE(offsetOfStartOfCentralDir);
        
        for (Integer fileLoop = 0; fileLoop < numberOfFiles; fileLoop++)
        {
            FileObject tempFile = new FileObject(zipfileString, offset);
            System.debug('File ' + tempFile.fileName);
            zipFileMap.put(EncodingUtil.convertFromHex(tempFile.fileName).toString(), tempFile);
            offset = tempFile.c_offsetToNextRecord;
        }
    }
    
    //  Returns a set of filenames from the current Zip archive.
    global Set<String> getFileNames()
    {
        System.debug('Archive contains ' + zipFileMap.size() + ' files');
        return zipFileMap.keySet().clone();
    }

    //Returns true if current archive contains the specified file
    global Boolean containsFile(String fileName)
    {
        return zipFileMap.containsKey(fileName);
    }

    global static void unzipAttachment(Id srcAttId, Id destObjId, String[] fileNames, Boolean attemptAsync){
        
        try {
            if (attemptAsync && !System.isFuture() && !System.isBatch()
                && Limits.getFutureCalls()<Limits.getLimitFutureCalls()){
                unzipAttachmentAsync(srcAttId, destObjId, fileNames);
                return;
            }
        } catch (Exception e){
            unzipAttachment(srcAttId, destObjId, fileNames, false);
            return;
        }

        Attachment src = [SELECT ParentId, Body FROM Attachment WHERE Id=:srcAttId];
        Attachment[] Atts = new List<Attachment>();

        Zippex myZippex = new Zippex(src.Body);

        if (destObjId == null){
            destObjId = src.ParentId;
        }

        if (fileNames == null){
            fileNames = new List<String>(myZippex.getFileNames());
        }
        Blob attBody;
        for (String fileName : fileNames) {
            attBody = myZippex.getFile(fileName);
            if (attBody != null ) {
                Atts.add(new Attachment (ParentId = destObjId,
                                      Name = fileName, 
                                      Body = myZippex.getFile(fileName)));
            }
            attBody = null;
            //if (Limits.getHeapSize() >= .2 * Limits.getLimitHeapSize()){
            //    insert Atts;
            //    Atts.clear();
            //}
        }
        insert Atts;
    }
    @future
    private static void unzipAttachmentAsync(Id srcAttId, Id destObjId, String[] fileNames){
        unzipAttachment(srcAttId, destObjId, fileNames, false);        
    }

    // Extracts the specified file contents from the current Zip archive.  If the file does not exist, returns null.
    global Blob getFile(String fileName)
    {
        System.debug('Lookin for file ' + fileName + ' in the archive');
        if (!zipFileMap.containsKey(fileName)) {return null;}

        FileObject tempFileObject = zipFileMap.get(fileName);

        if (tempFileObject.fileDataInZipStr) {
            tempFileObject.readLocalFileHeader(zipFileString, HexUtil.hexToIntLE(tempFileObject.offsetOfLH));
        }

        if (tempFileObject.compressionMethod == '0000')
        {
            return EncodingUtil.convertFromHex(tempFileObject.compressedFileData);
        }
        else if (tempFileObject.compressionMethod == '0800') //DEFLATED
        {
            return EncodingUtil.convertFromHex(new Puff(tempFileObject.compressedFileData,
                             HexUtil.hexToIntLE(tempFileObject.compressedSize),
                             HexUtil.hexToIntLE(tempFileObject.uncompressedSize)).inflate());
        }
        else {
            System.assert(false,'Unsupported compression method: ' + HexUtil.hexToIntLE(tempFileObject.compressionMethod));
            return null;
        }
    }
    //  Returns file metadata (lastModDateTime, crc32, fileSize, fileName, and fileComment).
    global Map<String,String> getFileInfo(String fileName)
    {
        Map<String,String> fileInfo = new Map<String,String>();
        if (!zipFileMap.containsKey(fileName)) {return null;}

        FileObject tmpFO = zipFileMap.get(fileName);

        fileInfo.put('lastModDateTime', String.valueOf(getLastModDateTime(HexUtil.hexToIntLE(tmpFO.lastModDate), HexUtil.hexToIntLE(tmpFO.lastModTime))));
        fileInfo.put('crc32', tmpFO.crc32);
        fileInfo.put('fileSize', String.valueOf( HexUtil.hexToIntLE(tmpFO.uncompressedSize)));
        fileInfo.put('fileName',  EncodingUtil.convertFromHex(tmpFO.fileName).toString());
        fileInfo.put('fileComment', EncodingUtil.convertFromHex(tmpFO.fileComment).toString());

        return fileInfo;
    }

    // Local File Header Signature
    private final static String LFHSignature = '504b0304';      
    
    // Central Directory Signature
    private final static String CFHSignature = '504b0102';

    // Data Descriptor Signature
    private final static String DDSignature  = '504b0708';

    // End of Central Directory records
    private final String endCentralDirSignature  = '504b0506'; //Little Endian formatted signature (4 bytes)
    private final String numberOfThisDisk        = '0000'; // (2 bytes)
    private final String numberOfTheDiskWithStartCentralDir = '0000'; //(2 bytes)
    private String entriesInCentralDirOnThisDisk = '0000' ;//(2 bytes)
    private String entriesCentralDir             = '0000'; //(2 bytes)
    private String sizeOfCentralDir              = '00000000'; //(4 bytes)
    private String offsetOfStartOfCentralDir     = '00000000'; //(4 bytes)
    private String zipfileCommentLength          = '0000';  //(this is c), (2 bytes)
    private String zipfileComment                = ''; // (c bytes)
    //////TO DO: preserve file comment!

    private String assembleEndOfCentralDir ()
    {
        return endCentralDirSignature + numberOfThisDisk + numberOfTheDiskWithStartCentralDir + entriesInCentralDirOnThisDisk +
            entriesCentralDir  + sizeOfCentralDir + offsetOfStartOfCentralDir +
            zipfileCommentLength + zipfileComment;
    }

    // Returns a Blob that contains the entire Zip archive.
    global Blob getZipArchive()
    {
        Integer zipFileSize;

        // delete central directory and end of Central directory
        zipFileString = zipFileString.left(HexUtil.hexToIntLE(offsetOfStartOfCentralDir)*2);

        //Writing Local Headers and data for each file not already in Zip string
        zipfileSize = zipFileString.length()/2;
        for (FileObject tempFileObject : zipFileMap.values())
        {
            if (!tempFileObject.fileDataInZipStr) {
                tempFileObject.offsetOfLH = HexUtil.intToHexLE(zipfileSize, 4);
                zipFileString += tempFileObject.assembleLocalFileHeader();
                zipfileSize = zipFileString.length()/2;
                tempFileObject.fileDataInZipStr = true;
                tempFileObject.compressedFileData = null;
            }
        }

        //Writing Central Directory
        offsetOfStartOfCentralDir = HexUtil.intToHexLE(zipfileSize,4);
        for (FileObject tempFileObject : zipFileMap.values())
        {
            zipFileString += tempFileObject.assembleCentralFileHeader();
        }
        sizeOfCentralDir = HexUtil.intToHexLE(zipFileString.length()/2 - zipfileSize,4);
        entriesInCentralDirOnThisDisk = HexUtil.intToHexLE(zipFileMap.size(),2);
        entriesCentralDir = HexUtil.intToHexLE(zipFileMap.size(),2);
        
        //Write End of Central Directory
        zipFileString += assembleEndOfCentralDir();
        
        //System.debug(zipFileString);
        return EncodingUtil.convertFromHex(zipFileString);
    }

    // Removes a file from the current Zip archive.
    global void removeFile(String fileName){

        if(!zipFileMap.containsKey(fileName)) {return;}

        FileObject tempFileObject = zipFileMap.get(fileName);

        if(tempFileObject.fileDataInZipStr) {
            Integer offsetOfLH = HexUtil.hexToIntLE(tempFileObject.offsetOfLH);
            tempFileObject.readLocalFileHeader(zipFileString, offsetOfLH);

            zipFileString = zipFileString.left(offsetOfLH*2) + zipFileString.substring(tempFileObject.l_offsetToNextRecord*2); 
            recalculateCentralDirOffsets(offsetOfLH, offsetOfLH - tempFileObject.l_offsetToNextRecord );
        }

        zipFileMap.remove(fileName);
    }

    private void recalculateCentralDirOffsets(Integer offset, Integer delta){
    
        for (FileObject tempFileObject : zipFileMap.values()){

            if(tempFileObject.fileDataInZipStr && HexUtil.hexToIntLE(tempFileObject.offsetOfLH) > offset){
                tempFileObject.offsetOfLH = HexUtil.intToHexLE(HexUtil.hexToIntLE(tempFileObject.offsetOfLH) + delta, 4);
            }
        }
        offsetOfStartOfCentralDir = HexUtil.intToHexLE(HexUtil.hexToIntLE(offsetOfStartOfCentralDir) + delta , 4);
    }

    //  Adds a new file to the current Zip archive.
    global void addFile(String fileName, Blob fileData, String crc32)
    {

        if(zipFileMap.containsKey(fileName)){
            removeFile(fileName);
        }

        FileObject tempFileObject = new FileObject();
        
        tempFileObject.lastModTime        = HexUtil.intToHexLE(getCurrentTime(),2); // (2 bytes) 
        tempFileObject.lastModDate        = HexUtil.intToHexLE(getCurrentDate(),2); // (2 bytes)
        tempFileObject.crc32              = crc32;
        tempFileObject.uncompressedSize   = HexUtil.intToHexLE(fileData.size(), 4);// (4 bytes) 
        tempFileObject.compressedSize     = tempFileObject.uncompressedSize;// (4 bytes), creates (n)    
        tempFileObject.extraFieldLength   = '0000';// (2 bytes) , creates (e)
        tempFileObject.fileCommentLength  = '0000';// (2 bytes), creates (c)
        tempFileObject.diskNumStart       = '0000';// (2 bytes) 
        tempFileObject.internalFileAtt    = '0000';// (2 bytes) //Internal file attributes
        tempFileObject.externalFileAtt    = '0000A481';// (4 bytes) //External file attributes
        tempFileObject.fileName           = EncodingUtil.convertToHex(Blob.valueOf(fileName));// (f bytes) // from the parameters passed
        tempFileObject.fileNameLength     = HexUtil.intToHexLE(tempFileObject.fileName.length()/2, 2);//HexUtil.intToHexLE(fileName.length(), 2);// (2 bytes), creates (f)
        tempFileObject.extraField         = '';
        tempFileObject.fileComment        = '';// (c bytes) 
        tempFileObject.compressedFileData = EncodingUtil.convertToHex(fileData); // (n bytes) // from the parameters passed
        tempFileObject.fileDataInZipStr   = false;

        zipFileMap.put(fileName, tempFileObject);  //add the new file to the file map
    }

    // Renames a file in the current Zip archive.
    global void renameFile(String oldName, String newName)
    {
        if (!zipFileMap.containsKey(oldName)) {return;}

        String newDataStr, oldDataStr, newFileNameLengthHex, oldNameHex, newNameHex;
        FileObject fileObj = zipFileMap.get(oldName);

        oldNameHex = EncodingUtil.convertToHex(Blob.valueOf(oldName));
        newNameHex = EncodingUtil.convertToHex(Blob.valueOf(newName));
        newFileNameLengthHex = HexUtil.intToHexLE(newNameHex.length()/2, 2);

        if (fileObj.fileDataInZipStr){
            oldDataStr = fileObj.fileNameLength + fileObj.extraFieldLength + oldNameHex + fileObj.extraField;
            newDataStr = newFileNameLengthHex + fileObj.extraFieldLength + newNameHex + fileObj.extraField;

            System.assert(zipFileString.contains(oldDataStr));
            zipFileString = zipFileString.replace(oldDataStr, newDataStr);
            recalculateCentralDirOffsets(HexUtil.hexToIntLE(fileObj.offsetOfLH), newNameHex.length()/2-oldNameHex.length()/2);
        }

        fileObj.fileName = newNameHex;
        fileObj.fileNameLength = newFileNameLengthHex;

        zipFileMap.remove(oldName);
        zipFileMap.put(newName, fileObj);
    }

    // Removes the specified prefix from all file names in the current Zip archive only if it occurs at the beginning of the file name.
    global void removePrefix(String prefix)
    {
        for (String fileName : zipFileMap.keySet()){
            if (fileName.startsWith(prefix)){
                renameFile(fileName, fileName.removeStart(prefix));
            }
        }
    }
    
    private static Integer getCurrentTime()
    {
        Datetime d = Datetime.now();
        Integer zipTimeStamp = d.hour();
        zipTimeStamp <<= 6;
        zipTimeStamp |= d.minute();
        zipTimeStamp <<= 5;
        zipTimeStamp |= d.second() / 2;
        
        return zipTimeStamp;
    }
    
    private static Integer getCurrentDate()
    {
        Datetime d = Datetime.now();
        Integer zipDateStamp = d.year() - 1980;
        zipDateStamp <<= 4;
        zipDateStamp |= d.month();
        zipDateStamp <<= 5;
        zipDateStamp |= d.day();
    
        return zipDateStamp;
    }

    global static DateTime getLastModDateTime(Integer lastModDate, Integer lastModtime)
    {
        Integer year, month, day, hour, minute, second;
        day = lastModDate & 31;
        lastModDate >>>= 5;
        month = lastModDate & 15;
        lastModDate >>>= 4;
        year = lastModDate + 1980;

        second = (lastModTime & 31) * 2;
        lastModTime >>>= 5;
        minute = lastModTime & 63;
        lastModTime >>>= 6;
        hour = lastModTime;

        return DateTime.newInstance(year, month, day, hour, minute, second);
    }



    global class FileObject
    {
        //All strings are hex representations in little endian format
        global String creatorVersion      = '0A00';     // (2 bytes) likely Windows NT
        global String minExtractorVersion = '0A00';     // (2 bytes) likely Windows NT
        global String gPFlagBit           = '0000';     // (2 bytes) general purpose flag bit
        global String compressionMethod   = '0000';     // (2 bytes) 0 = no compression
        global String lastModTime         = '0000';     // (2 bytes) 
        global String lastModDate         = '0000';     // (2 bytes) 
        global String crc32               = null;       // (4 bytes) 
        global String compressedSize      = '00000000'; // (4 bytes), creates (n)
        global String uncompressedSize    = '00000000'; // (4 bytes) 
        global String fileNameLength      = '00000000'; // (2 bytes), creates (f)
        global String extraFieldLength    = '0000';     // (2 bytes), creates (e)
        global String fileCommentLength   = '0000';     // (2 bytes), creates (c)
        global String diskNumStart        = '0000';     // (2 bytes) 
        global String internalFileAtt     = '0000';     // (2 bytes) 
        global String externalFileAtt     = '00000000'; // (4 bytes) 
        global String offsetOfLH          = '00000000'; // (4 bytes) 
        global String fileName            = '';         // (f bytes) 
        global String extraField          = '';         // (e bytes) 
        global String fileComment         = '';         // (c bytes) 
        global String compressedFileData  = '';         // (n bytes)

        global Integer c_offsetToNextRecord = 0;  //offsetToNext Central Dir Record
        global Integer l_offsetToNextRecord = 0;  //offsetToNext Local Header Record
        global Boolean fileDataInZipStr     = false;

    
        // Constructor
        global FileObject(){
            fileDataInZipStr = false;
        }

        //Reading Central Directory File Header
        global FileObject (String zipFileString, Integer offset)
        {
        offset *= 2;

        creatorVersion      = zipFileString.mid(offset+4*2,  2*2);// (2 bytes) likely Windows NT  Offset 4
        minExtractorVersion = zipFileString.mid(offset+6*2,  2*2);// (2 bytes) likely Windows NT  Offset 6
        gPFlagBit           = zipFileString.mid(offset+8*2,  2*2);// (2 bytes) general purpose flag bit  Offset 8
        compressionMethod   = zipFileString.mid(offset+10*2, 2*2);// (2 bytes) no compression  Offset 10
        lastModTime         = zipFileString.mid(offset+12*2, 2*2);// (2 bytes)   Offset 12
        lastModDate         = zipFileString.mid(offset+14*2, 2*2);// (2 bytes)   Offset 14
        crc32               = zipFileString.mid(offset+16*2, 4*2);// (4 bytes)   Offset 16
        compressedSize      = zipFileString.mid(offset+20*2, 4*2);// (4 bytes)   creates (n) Offset 20
        uncompressedSize    = zipFileString.mid(offset+24*2, 4*2);// (4 bytes)   Offset 24
        fileNameLength      = zipFileString.mid(offset+28*2, 2*2);// (2 bytes)   creates (f) Offset 28
        extraFieldLength    = zipFileString.mid(offset+30*2, 2*2);// (2 bytes)   creates (e) Offset 30
        fileCommentLength   = zipFileString.mid(offset+32*2, 2*2);// (2 bytes)   creates (c) Offset 32
        diskNumStart        = zipFileString.mid(offset+34*2, 2*2);// (2 bytes)   Offset 34
        internalFileAtt     = zipFileString.mid(offset+36*2, 2*2);// (2 bytes)   Offset 36
        externalFileAtt     = zipFileString.mid(offset+38*2, 4*2);// (4 bytes)   Offset 38
        offsetOfLH          = zipFileString.mid(offset+42*2, 4*2);// (4 bytes)   Offset 42
        
        offset /= 2;

        Integer theStart = offset+46;
        Integer theEnd = theStart + HexUtil.hexToIntLE(fileNameLength);
        fileName = zipFileString.substring(theStart*2, theEnd*2);// (f bytes)       Offset 46
        theStart = theEnd;
        theEnd = theStart + HexUtil.hexToIntLE(extraFieldLength);
        extraField = zipFileString.substring(theStart*2, theEnd * 2);// (e bytes)        Offset 46 + fileNameLength
        theStart = theEnd;
        theEnd = theStart + HexUtil.hexToIntLE(fileCommentLength);
        fileComment = zipFileString.substring(theStart*2, theEnd*2);// (c bytes)        Offset 46 + fileNameLength + extraFieldLength
        c_offsetToNextRecord = theEnd;
        fileDataInZipStr = true; //true because we are reading an existing Zip archive
        //System.debug(this);
        }
        
        //Reading Local File Header (which also contains the data)
        global void readLocalFileHeader (String zipFileString, Integer offset)
        {
            Integer strOffset = offset *2;

            minExtractorVersion  = zipFileString.mid(strOffset+4*2,  2*2);// (2 bytes) likely Windows NT  Offset 4
            gPFlagBit            = zipFileString.mid(strOffset+6*2,  2*2);// (2 bytes) general purpose flag bit  Offset 6
            compressionMethod    = zipFileString.mid(strOffset+8*2,  2*2);// (2 bytes) no compression  Offset 8
            lastModTime          = zipFileString.mid(strOffset+10*2, 2*2);// (2 bytes)  Offset 10
            lastModDate          = zipFileString.mid(strOffset+12*2, 2*2);// (2 bytes)  Offset 12
            
            //System.debug('gPFlagBit '+gPFlagBit);
            if ((HexUtil.hexToIntLE(gPFlagBit.left(2)) & 8 ) == 0) {
                crc32            = zipFileString.mid(strOffset+14*2, 4*2);// (4 bytes)  Offset 14
                compressedSize   = zipFileString.mid(strOffset+18*2, 4*2);// (4 bytes), creates (n) Offset 18
                uncompressedSize = zipFileString.mid(strOffset+22*2, 4*2);// (4 bytes)  Offset 22
            }

            fileNameLength       = zipFileString.mid(strOffset+26*2, 2*2);// (2 bytes), creates (f)     Offset 26
            extraFieldLength     = zipFileString.mid(strOffset+28*2, 2*2);// (2 bytes), creates (e)     Offset 28

            //offset = offset /2;

            Integer theStart = offset+30;
            Integer theEnd = theStart + HexUtil.hexToIntLE(fileNameLength);
            fileName = zipFileString.substring(theStart*2, theEnd*2);// (f bytes)       Offset 30
            theStart = theEnd;
            theEnd = theStart + HexUtil.hexToIntLE(extraFieldLength);
            extraField = zipFileString.substring(theStart*2, theEnd*2);// (e bytes)        Offset 30 + fileNameLength
            theStart = theEnd;
            theEnd = theStart + HexUtil.hexToIntLE(compressedSize);
            compressedFileData = zipFileString.substring(theStart*2, theEnd*2);// (c bytes)        Offset 30 + fileNameLength + extraFieldLength
            l_offsetToNextRecord = theEnd;
            
            if ((HexUtil.hexToIntLE(gPFlagBit.left(2)) & 8 ) != 0) {
                l_offsetToNextRecord *= 2;
                String signature = zipFileString.mid(l_offsetToNextRecord+0*2, 4*2); // (4 bytes)
                if (signature != DDSignature) {l_offsetToNextRecord -= 4*2;}
                crc32            = zipFileString.mid(l_offsetToNextRecord+4*2, 4*2); // (4 bytes)  Offset 0/4
                compressedSize   = zipFileString.mid(l_offsetToNextRecord+8*2, 4*2); // (4 bytes), creates (n)     Offset 4/8
                uncompressedSize = zipFileString.mid(l_offsetToNextRecord+12*2, 4*2);// (4 bytes)  Offset 8/12
                l_offsetToNextRecord /= 2;
                l_offsetToNextRecord += 16; 
            }
        }

        global String assembleLocalFileHeader()
        {
            if (String.isBlank(crc32)) {  
                crc32 = HexUtil.intToHexLE(HexUtil.CRC32Table(compressedFileData), 4);// (4 bytes) 
            }

            l_offsetToNextRecord = HexUtil.hexToIntLE(offsetOfLH) 
                                 + 30 
                                 + HexUtil.hexToIntLE(fileNameLength)
                                 + HexUtil.hexToIntLE(extraFieldLength)
                                 + HexUtil.hexToIntLE(compressedSize);

            return Zippex.LFHSignature + minExtractorVersion + gPFlagBit + compressionMethod + lastModTime 
                    + lastModDate + crc32 + compressedSize + uncompressedSize + fileNameLength + extraFieldLength 
                    + fileName + extraField + compressedFileData;
        }

        global String assembleCentralFileHeader()
        {
            if (String.isBlank(crc32)) {  
                crc32 = HexUtil.intToHexLE(HexUtil.CRC32Table(compressedFileData), 4);// (4 bytes) 
            }
            return Zippex.CFHSignature + creatorVersion + minExtractorVersion + gPFlagBit + compressionMethod + lastModTime 
                    + lastModDate + crc32 + compressedSize + uncompressedSize + fileNameLength + extraFieldLength
                    + fileCommentLength + diskNumStart + internalFileAtt + externalFileAtt + offsetOfLH + fileName 
                    + extraField + fileComment;
        }
    }// end of FileObject class
}