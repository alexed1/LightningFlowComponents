@isTest
public with sharing class ers_SliceTextTest {
    
    static testMethod void sliceTextTest() {

        String testSourceText = 'AB12CDEF12GHI';
        String testSearchBegin = '';
        String testSearchEnd = '';
        Boolean testReverse = false;

        ers_SliceText.Requests testRequest = new ers_SliceText.Requests();
        List<ers_SliceText.Requests> testRequestList = new List<ers_SliceText.Requests>();

        // Test valid slice with start and end
        testRequest.sourceText = testSourceText;
        testRequest.searchBegin = '12';
        testRequest.searchEnd = '12';
        testRequest.reverseSearch = false;
        testRequestList.add(testRequest);
        List<ers_SliceText.Results> testResultList = ers_SliceText.sliceText(testRequestList);
        Assert.areEqual('AB', testResultList[0].textBefore);
        Assert.areEqual('12CDEF12', testResultList[0].textExtract);
        Assert.areEqual('CDEF', testResultList[0].textInner);
        Assert.areEqual('GHI', testResultList[0].textAfter);
        Assert.isFalse(testResultList[0].notFound);
        testRequestList.clear();

        // Test valid slice with start only
        testRequest.sourceText = testSourceText;
        testRequest.searchBegin = '12';
        testRequest.searchEnd = '';
        testRequest.reverseSearch = false;
        testRequestList.add(testRequest);
        testResultList = ers_SliceText.sliceText(testRequestList);
        Assert.areEqual('AB', testResultList[0].textBefore);
        Assert.areEqual('12', testResultList[0].textExtract);
        Assert.areEqual('', testResultList[0].textInner);
        Assert.areEqual('CDEF12GHI', testResultList[0].textAfter);
        Assert.isFalse(testResultList[0].notFound);
        testRequestList.clear();

        // Test valid reverse slice with start and end
        testRequest.sourceText = testSourceText + testSourceText;
        testRequest.searchBegin = '12';
        testRequest.searchEnd = '12';
        testRequest.reverseSearch = true;
        testRequestList.add(testRequest);
        testResultList = ers_SliceText.sliceText(testRequestList);
        Assert.areEqual('AB12CDEF12GHIAB', testResultList[0].textBefore);
        Assert.areEqual('12CDEF12', testResultList[0].textExtract);
        Assert.areEqual('CDEF', testResultList[0].textInner);
        Assert.areEqual('GHI', testResultList[0].textAfter);
        Assert.isFalse(testResultList[0].notFound);
        testRequestList.clear();

        // Test valid reverse slice with start only
        testRequest.sourceText = testSourceText;
        testRequest.searchBegin = '12';
        testRequest.searchEnd = '';
        testRequest.reverseSearch = true;
        testRequestList.add(testRequest);
        testResultList = ers_SliceText.sliceText(testRequestList);
        Assert.areEqual('AB12CDEF', testResultList[0].textBefore);
        Assert.areEqual('12', testResultList[0].textExtract);
        Assert.areEqual('', testResultList[0].textInner);
        Assert.areEqual('GHI', testResultList[0].textAfter);
        Assert.isFalse(testResultList[0].notFound);
        testRequestList.clear();

        // Test invalid slice with bad start
        testRequest.sourceText = testSourceText;
        testRequest.searchBegin = '1X';
        testRequest.searchEnd = '12';
        testRequest.reverseSearch = false;
        testRequestList.add(testRequest);
        testResultList = ers_SliceText.sliceText(testRequestList);
        Assert.areEqual('AB12CDEF12GHI', testResultList[0].textBefore);
        Assert.areEqual('', testResultList[0].textExtract);
        Assert.areEqual('', testResultList[0].textInner);
        Assert.areEqual('', testResultList[0].textAfter);
        Assert.isTrue(testResultList[0].notFound);
        testRequestList.clear();

        // Test invalid slice with good start and bad end
        testRequest.sourceText = testSourceText;
        testRequest.searchBegin = '12';
        testRequest.searchEnd = '1X';
        testRequest.reverseSearch = false;
        testRequestList.add(testRequest);
        testResultList = ers_SliceText.sliceText(testRequestList);
        Assert.isTrue(testResultList[0].notFound);
        testRequestList.clear();        
        
    }

}