/*
Copyright (c) 2018, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 *
 * Unit tests for ConnectApiHelper.
 *
 * This class works with API version 43.0 and later. There are separate classes
 * that work with v42.0 and earlier.
 *
 * See https://github.com/forcedotcom/ConnectApiHelper for more information.
 *
 */

@IsTest(SeeAllData=true)
public class ConnectApiHelperTest {

    @IsTest(SeeAllData=true)
    static void testInvalidMentionType() {
        Boolean exceptionThrown = false;
        try {
            ConnectApiHelper.postFeedItemWithMentions(null, 'me', '{001x00000000D7m}'); // not a group or user id
        }
        catch (ConnectApi.ConnectApiException e) {
            System.assertEquals('Only user and group IDs may be used in inline mentions.', e.getMessage());
            exceptionThrown = true;
        }
        System.assert(exceptionThrown);
    }

    @IsTest(SeeAllData=true)
    static void testNullString() {
        Boolean exceptionThrown = false;
        try {
            List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(null);
        }
        catch (ConnectApiHelper.InvalidParameterException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown);
    }

    @IsTest(SeeAllData=true)
    static void testEmptyString() {
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs('');
        System.assertEquals(0, segments.size());
    }

    @IsTest(SeeAllData=true)
    static void testNoMentions() {
        String text = 'hey there';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(text, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testMentionOnly() {
        String mentionId = '005x0000000URNP';
        String text = '{' + mentionId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.id);
    }

    @IsTest(SeeAllData=true)
    static void testLeadingMention() {
        String mentionId = '005x0000000URNPzzz';
        String restOfMessage = ' - how are you?';
        String text = '{' + mentionId + '}' + restOfMessage;
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.id);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(restOfMessage, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testTrailingMention() {
        String restOfMessage = 'Here we go: ';
        String mentionId = '005x0000000URNPzzz';
        String text = restOfMessage + '{' + mentionId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MentionSegmentInput);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(restOfMessage, textSegment.text);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(1);
        System.assertEquals(mentionId, mentionSegment.id);
    }

    @IsTest(SeeAllData=true)
    static void testAdjacentMentions() {
        String mentionId  = '005x0000000URNPzzz';
        String mentionId2 = '0F9x00000000D7m';
        String text = '{' + mentionId + '}' + '{' + mentionId2 + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MentionSegmentInput);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.id);

        ConnectApi.MentionSegmentInput mentionSegment2 = (ConnectApi.MentionSegmentInput) segments.get(1);
        System.assertEquals(mentionId2, mentionSegment2.id);
    }

    @IsTest(SeeAllData=true)
    static void testLinkAndHashtagParsing() {
        // The test string is: #Yolo: http://salesforce.com, {005} {005x0000000URNPzzz} test.
        //                     [   ][][                   ][      ][                  ][    ]
        //                     0    1 2                    3       4                   5
        // 0 = hashtag
        // 1 = text1
        // 2 = link
        // 3 = text2
        // 4 = mention
        // 5 = text3

        String hashtag = 'Yolo';
        String text1 = ': ';
        String link = 'http://salesforce.com';
        String text2 = ', {005} ';
        String mentionId = UserInfo.getUserId();
        String text3 = ' test.';
        String text = '#' + hashtag + text1 + link + text2 + '{' + mentionId + '}' + text3;

        ConnectApi.FeedElement fi = ConnectApiHelper.postFeedItemWithRichText(null, 'me', text);

        List<ConnectApi.MessageSegment> segments = fi.body.messageSegments;

        System.assertEquals(6, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.HashtagSegment);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegment);
        System.assert(segments.get(2) instanceof ConnectApi.LinkSegment);
        System.assert(segments.get(3) instanceof ConnectApi.TextSegment);
        System.assert(segments.get(4) instanceof ConnectApi.MentionSegment);
        System.assert(segments.get(5) instanceof ConnectApi.TextSegment);

        ConnectApi.HashtagSegment hashtagSegment = (ConnectApi.HashtagSegment) segments.get(0);
        System.assertEquals(hashtag, hashtagSegment.tag);

        ConnectApi.TextSegment textSegment1 = (ConnectApi.TextSegment) segments.get(1);
        System.assertEquals(text1, textSegment1.text);

        ConnectApi.LinkSegment linkSegment = (ConnectApi.LinkSegment) segments.get(2);
        System.assertEquals(link, linkSegment.url);

        ConnectApi.TextSegment textSegment2 = (ConnectApi.TextSegment) segments.get(3);
        System.assertEquals(text2, textSegment2.text);

        ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) segments.get(4);
        System.assertEquals(mentionId, mentionSegment.record.id);

        ConnectApi.TextSegment textSegment3 = (ConnectApi.TextSegment) segments.get(5);
        System.assertEquals(text3, textSegment3.text);
    }

    @IsTest(SeeAllData=true)
    static void testMentionInComment() {
        ConnectApi.FeedElement fi = ConnectApi.ChatterFeeds.postFeedElement(null, 'me', ConnectApi.FeedElementType.FeedItem, 'hi');
        String mentionId = UserInfo.getUserId();
        String text = '{' + mentionId + '}';
        ConnectApi.Comment comment = ConnectApiHelper.postCommentWithMentions(null, fi.id, text);

        List<ConnectApi.MessageSegment> segments = comment.body.messageSegments;
        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegment);
        ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.record.id);
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBody() {

        // We'll post a feed item that contains text, link, hashtag, mention, and markup segments,
        // and then call the helper method on the resulting body.

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        // We can put the link and hashtag parts into a text segment to post the feed item. When it gets retrieved, it will have
        // separate segments for the text, link and hashtag.
        String expectedText = 'Text ';
        String expectedLink = 'http://link.com';
        String expectedHashtag = 'hashtag';
        String expectedBoldText = 'Bold text';

        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = expectedText + expectedLink + ' #' + expectedHashtag;
        messageBodyInput.messageSegments.add(textSegmentInput);

        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        mentionSegmentInput.id = UserInfo.getUserId();
        messageBodyInput.messageSegments.add(mentionSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegmentInput = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegmentInput.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupBeginSegmentInput);

        textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = expectedBoldText;
        messageBodyInput.messageSegments.add(textSegmentInput);

        ConnectApi.MarkupEndSegmentInput markupEndSegmentInput = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegmentInput.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupEndSegmentInput);

        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = UserInfo.getUserId();

        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(feedElement.body);
        System.assertEquals(8, input.messageSegments.size(), 'Wrong number of message segments.');

        System.assert(input.messageSegments.get(0) instanceof ConnectApi.TextSegmentInput, 'Segment 0 is not a text segment input.');
        ConnectApi.TextSegmentInput textInput = (ConnectApi.TextSegmentInput) input.messageSegments.get(0);
        System.assertEquals(expectedText, textInput.text, 'Segment 0 text does not match.');

        System.assert(input.messageSegments.get(1) instanceof ConnectApi.LinkSegmentInput, 'Segment 1 is not a link segment input.');
        ConnectApi.LinkSegmentInput linkInput = (ConnectApi.LinkSegmentInput) input.messageSegments.get(1);
        System.assertEquals(expectedLink, linkInput.url, 'Segment 1 url does not match.');

        System.assert(input.messageSegments.get(2) instanceof ConnectApi.TextSegmentInput, 'Segment 2 is not a text segment input.');
        ConnectApi.TextSegmentInput textInput2 = (ConnectApi.TextSegmentInput) input.messageSegments.get(2);
        System.assertEquals(' ', textInput2.text, 'Segment 2 text does not match.');

        System.assert(input.messageSegments.get(3) instanceof ConnectApi.HashtagSegmentInput, 'Segment 3 is not a hashtag segment input.');
        ConnectApi.HashtagSegmentInput hashtagInput = (ConnectApi.HashtagSegmentInput) input.messageSegments.get(3);
        System.assertEquals(expectedHashtag, hashtagInput.tag, 'Segment 3 hashtag does not match.');

        System.assert(input.messageSegments.get(4) instanceof ConnectApi.MentionSegmentInput, 'Segment 4 is not a mention segment input.');
        ConnectApi.MentionSegmentInput mentionInput = (ConnectApi.MentionSegmentInput) input.messageSegments.get(4);
        System.assertEquals(UserInfo.getUserId(), mentionInput.id, 'Segment 4 mention ID does not match.');

        System.assert(input.messageSegments.get(5) instanceof ConnectApi.MarkupBeginSegmentInput, 'Segment 5 is not a markup begin segment input.');
        ConnectApi.MarkupBeginSegmentInput markupBeginInput = (ConnectApi.MarkupBeginSegmentInput) input.messageSegments.get(5);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginInput.markupType, 'Segment 5 markup type does not match.');

        System.assert(input.messageSegments.get(6) instanceof ConnectApi.TextSegmentInput, 'Segment 6 is not a text segment input.');
        ConnectApi.TextSegmentInput textInput3 = (ConnectApi.TextSegmentInput) input.messageSegments.get(6);
        System.assertEquals(expectedBoldText, textInput3.text, 'Segment 6 text does not match.');

        System.assert(input.messageSegments.get(7) instanceof ConnectApi.MarkupEndSegmentInput, 'Segment 7 is not a markup end segment input.');
        ConnectApi.MarkupEndSegmentInput markupEndInput = (ConnectApi.MarkupEndSegmentInput) input.messageSegments.get(7);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndInput.markupType, 'Segment 7 markup type does not match.');

        // Get coverage for the createFeedItemInputFromBody() method.
        ConnectApi.FeedItemInput feedItemInput2 = ConnectApiHelper.createFeedItemInputFromBody(feedElement.body);
        System.assertEquals(input, feedItemInput2.body, 'createFeedItemInputFromBody is returning a different input body than createInputFromBody.');

        // Get coverage for the createCommentInputFromBody() method.
        ConnectApi.CommentInput commentInput = ConnectApiHelper.createCommentInputFromBody(feedElement.body);
        System.assertEquals(input, commentInput.body, 'createCommentInputFromBody is returning a different input body than createInputFromBody.');
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBodyWithGeneratedSegment() {
        ConnectApi.FeedBody body = new ConnectApi.FeedBody();
        body.messageSegments = new List<ConnectApi.MessageSegment>();

        // Mock up an entity link segment.
        ConnectApi.EntityLinkSegment entityLinkSegment = new ConnectApi.EntityLinkSegment();
        entityLinkSegment.text = 'blah';

        body.messageSegments.add(entityLinkSegment);
        body.text = 'blah';

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(body);
        System.assertEquals(0, input.messageSegments.size(), 'Wrong number of message segments.');
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBodyWithNewLine() {
        // In order for newlines to display properly in rich text, they need to be turned into
        // paragraph markup segments.
        ConnectApi.FeedBody body = new ConnectApi.FeedBody();
        body.messageSegments = new List<ConnectApi.MessageSegment>();

        // Mock up an text segment containing a newline character.
        ConnectApi.TextSegment textSegment = new ConnectApi.TextSegment();
        String newline = EncodingUtil.urlDecode('%0A', 'UTF-8'); 
        textSegment.text = 'foo' + newline + 'bar';

        body.messageSegments.add(textSegment);
        body.text = textSegment.text;

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(body);
        // We expect 4 segments:
        // 1. TextSegmentInput 'foo'
        // 2. MarkupBeginSegmentInput for <p>
        // 3. MarkupEndSegmentInput for <p>
        // 4. TextSegmentInput 'bar'
        System.assertEquals(4, input.messageSegments.size(), 'Wrong number of message segments.');
        System.assert(input.messageSegments[0] instanceof ConnectApi.TextSegmentInput, 'Wrong type for input 0');
        System.assert(input.messageSegments[1] instanceof ConnectApi.MarkupBeginSegmentInput, 'Wrong type for input 1');
        System.assert(input.messageSegments[2] instanceof ConnectApi.MarkupEndSegmentInput, 'Wrong type for input 2');
        System.assert(input.messageSegments[3] instanceof ConnectApi.TextSegmentInput, 'Wrong type for input 3');
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBodyWithTwoNewLines() {
        // In order for newlines to display properly in rich text, they need to be turned into
        // paragraph markup segments.
        
        ConnectApi.FeedBody body = new ConnectApi.FeedBody();
        body.messageSegments = new List<ConnectApi.MessageSegment>();

        // Mock up an text segment containing a newline character.
        ConnectApi.TextSegment textSegment = new ConnectApi.TextSegment();
        String newline = EncodingUtil.urlDecode('%0A', 'UTF-8'); 
        textSegment.text = 'foo' + newline + newline + 'bar';

        body.messageSegments.add(textSegment);
        body.text = textSegment.text;

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(body);
        // We expect 5 segments:
        // 1. TextSegmentInput 'foo'
        // 2. MarkupBeginSegmentInput for <p>
        // 3. TextSegmentInput '&nbsp;'
        // 4. MarkupEndSegmentInput for <p>
        // 5. TextSegmentInput 'bar'
        System.assertEquals(5, input.messageSegments.size(), 'Wrong number of message segments.');
        System.assert(input.messageSegments[0] instanceof ConnectApi.TextSegmentInput, 'Wrong type for input 0');
        System.assert(input.messageSegments[1] instanceof ConnectApi.MarkupBeginSegmentInput, 'Wrong type for input 1');
        System.assert(input.messageSegments[2] instanceof ConnectApi.TextSegmentInput, 'Wrong type for input 2');
        System.assert(input.messageSegments[3] instanceof ConnectApi.MarkupEndSegmentInput, 'Wrong type for input 3');
        System.assert(input.messageSegments[4] instanceof ConnectApi.TextSegmentInput, 'Wrong type for input 4');
    }
    
    @IsTest(SeeAllData=true)
    static void testUnsupportedMarkup() {
        // <span>a</span>, <h1><a>b</a> <br> <b>Does this work?</b></h1>
        // [0                               ][1][2            ][3 ][4  ]
        // 0 = text1
        // 1 = markup begin
        // 2 = text2
        // 3 = markup end
        // 4 = text3
        String text1 = '<span>a</span>, <h1><a>b</a> <br> ';
        String text2 = 'Does this work?';
        String text3 = '</h1>';
        String text = text1 + '<b>' + text2 + '</b>' + text3;

        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(5, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.TextSegmentInput);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(text1, textSegment.text);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
        System.assertEquals(text2, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
        System.assertEquals(text3, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testSimpleMarkup() {
        String restOfMessage = 'blah';
        String text = '<u>' + restOfMessage + '</u>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(3, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.MarkupEndSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(restOfMessage, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);
    }

    @IsTest(SeeAllData=true)
    static void testMarkupCasing() {
        String text1 = 'foo';
        String text2 = 'bar';
        String text3 = 'baz';
        String text = '<U>' + text1 + '</U><b>' + text2 + '</B><oL><li>' + text3 + '</li></oL>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(11, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(5) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(6) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(7) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(8) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(9) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(10) instanceof ConnectApi.MarkupEndSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(text1, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(3);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
        System.assertEquals(text2, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(5);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
        System.assertEquals(text3, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);
    }

    @IsTest(SeeAllData=true)
    static void testInlineImage() {
        String restOfMessage = 'Check out this image!';
        String imageId = '069B0000000q7hi';
        String altText = 'Some alt text.';
        String text = restOfMessage + '{img:' + imageId + ':' + altText + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.InlineImageSegmentInput);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(restOfMessage, textSegment.text);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
        System.assertEquals(imageId, inlineImageSegment.fileId);
        System.assertEquals(altText, inlineImageSegment.altText);
    }

    @IsTest(SeeAllData=true)
    static void testInlineImageNoAltText() {
        String imageId = '069B0000000q7hi';
        String text = '{img:' + imageId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.InlineImageSegmentInput);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
        System.assertEquals(imageId, inlineImageSegment.fileId);
        System.assertEquals(null, inlineImageSegment.altText);
    }

    @IsTest(SeeAllData=true)
    static void testInlineImageAltTextSyntax() {
        String imageId15 = '069B0000000q7hi';
        String imageId18 = '069B0000000q7hixxx';
        String altText1 = 'Alt text with a colon : in the middle.';
        String badSyntax1 = 'Alt text with a closing brace ';
        String badSyntax2 = ' in the middle.}';
        String badSyntaxAltText = badSyntax1 + '}' + badSyntax2;
        String text = '{img:' + imageId15 + ':' + altText1 + '}{img:' + imageId18 + ':}{img:' + imageId15 + ':' + badSyntaxAltText;
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(4, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.InlineImageSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.InlineImageSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.InlineImageSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.TextSegmentInput);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
        System.assertEquals(imageId15, inlineImageSegment.fileId);
        System.assertEquals(altText1, inlineImageSegment.altText);

        inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
        System.assertEquals(imageId18, inlineImageSegment.fileId);
        System.assertEquals(null, inlineImageSegment.altText);

        inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(2);
        System.assertEquals(imageId15, inlineImageSegment.fileId);
        System.assertEquals(badSyntax1, inlineImageSegment.altText);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(3);
        System.assertEquals(badSyntax2, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testRecordMention18CharId() {
        String recordId = '01t3E000002GCm9QAG';
        String text = '{record:' + recordId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.EntityLinkSegmentInput);

        ConnectApi.EntityLinkSegmentInput recordSegment = (ConnectApi.EntityLinkSegmentInput) segments.get(0);
        System.assertEquals(recordId, recordSegment.entityId);
    }

    @IsTest(SeeAllData=true)
    static void testRecordMention15CharId() {
        String recordId = '01t3E000002GCm9';
        String text = '{record:' + recordId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.EntityLinkSegmentInput);

        ConnectApi.EntityLinkSegmentInput recordSegment = (ConnectApi.EntityLinkSegmentInput) segments.get(0);
        System.assertEquals(recordId, recordSegment.entityId);
    }

    @IsTest(SeeAllData=true)
    static void testMarkupAndMention() {
        String mentionId = '005x0000000URNPzzz';
        String message = 'How are you';
        String questionMark = '?';
        String text = '<b>' + message + '<i>{' + mentionId + '}</i>' + questionMark + '</b>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(7, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MentionSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(5) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(6) instanceof ConnectApi.MarkupEndSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(message, textSegment.text);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(2);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(3);
        System.assertEquals(mentionId, mentionSegment.id);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(5);
        System.assertEquals(questionMark, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(6);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);
    }

    @IsTest(SeeAllData=true)
    static void testAllMarkupAndInlineImage() {
        // <p><i>This is an italicized paragraph.</i></p>
        // <ul><li><s>A completed item in an unordered list.</s></li></ul>
        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        // <code>int foo = 1 / 0;</code>
        String text1 = 'This is an italicized paragraph.';
        String text2 = 'A completed item in an unordered list.';
        String text3 = 'An underlined item in an ordered list.';
        String text4 = 'And, of course, an image for you: ';
        String text5 = ' ';
        String imageId = '069B0000000q7hi';
        String altText = 'An image of something nice.';
        String code = 'int foo = 1 / 0;';
        String text = '<p><i>' + text1 + '</i></p><ul><li><s>' + text2 + '</s></li></ul><ol><li><u>'
                        + text3 + '</u></li></ol><b>' + text4 + '</b> {img:' + imageId + ':' + altText + '}'
                        + '<code>' + code + '</code>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(27, segments.size());
        // <p><i>This is an italicized paragraph.</i></p>
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.MarkupEndSegmentInput);

        // <ul><li><s>A completed item in an unordered list.</s></li></ul>
        System.assert(segments.get(5) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(6) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(7) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(8) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(9) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(10) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(11) instanceof ConnectApi.MarkupEndSegmentInput);

        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        System.assert(segments.get(12) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(13) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(14) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(15) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(16) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(17) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(18) instanceof ConnectApi.MarkupEndSegmentInput);

        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        System.assert(segments.get(19) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(20) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(21) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(22) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(23) instanceof ConnectApi.InlineImageSegmentInput);

        // <code>int foo = 1 / 0;</code>
        System.assert(segments.get(24) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(25) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(26) instanceof ConnectApi.MarkupEndSegmentInput);

        // <p><i>This is an italicized paragraph.</i></p>
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Paragraph, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
        System.assertEquals(text1, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
        System.assertEquals(ConnectApi.MarkupType.Paragraph, markupEndSegment.markupType);

        // <ul><li><s>A completed item in an unordered list.</s></li></ul>
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(5);
        System.assertEquals(ConnectApi.MarkupType.UnorderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
        System.assertEquals(ConnectApi.MarkupType.Strikethrough, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
        System.assertEquals(text2, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
        System.assertEquals(ConnectApi.MarkupType.Strikethrough, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(11);
        System.assertEquals(ConnectApi.MarkupType.UnorderedList, markupEndSegment.markupType);

        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(12);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(13);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(14);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(15);
        System.assertEquals(text3, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(16);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(17);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(18);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);

        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(19);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(20);
        System.assertEquals(text4, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(21);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(22);
        System.assertEquals(text5, textSegment.text);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(23);
        System.assertEquals(imageId, inlineImageSegment.fileId);
        System.assertEquals(altText, inlineImageSegment.altText);

        // <code>int foo = 1 / 0;</code>
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(24);
        System.assertEquals(ConnectApi.MarkupType.Code, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(25);
        System.assertEquals(code, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(26);
        System.assertEquals(ConnectApi.MarkupType.Code, markupEndSegment.markupType);

    }
}
