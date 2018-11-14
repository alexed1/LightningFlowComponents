@isTest
public class SheetsSheetResponseTest {
    
    @isTest    
	static void testParse() {
		String json=		'{'+
		' "spreadsheetId": "1A7Td7yl6wbxGhlsjouwO-N3sRyTDq-M5p579awuYTQo",'+
		' "properties": {'+
		'  "title": "Api Test",'+
		'  "locale": "en_US",'+
		'  "autoRecalc": "ON_CHANGE",'+
		'  "timeZone": "America/Los_Angeles",'+
		'  "defaultFormat": {'+
		'   "backgroundColor": {'+
		'    "red": 1,'+
		'    "green": 1,'+
		'    "blue": 1'+
		'   },'+
		'   "padding": {'+
		'    "top": 2,'+
		'    "right": 3,'+
		'    "bottom": 2,'+
		'    "left": 3'+
		'   },'+
		'   "verticalAlignment": "BOTTOM",'+
		'   "wrapStrategy": "OVERFLOW_CELL",'+
		'   "textFormat": {'+
		'    "foregroundColor": {'+
		'    },'+
		'    "fontFamily": "arial,sans,sans-serif",'+
		'    "fontSize": 10,'+
		'    "bold": false,'+
		'    "italic": false,'+
		'    "strikethrough": false,'+
		'    "underline": false'+
		'   }'+
		'  }'+
		' },'+
		' "sheets": ['+
		'  {'+
		'   "properties": {'+
		'    "sheetId": 0,'+
		'    "title": "Sheet1",'+
		'    "index": 0,'+
		'    "sheetType": "GRID",'+
		'    "gridProperties": {'+
		'     "rowCount": 1000,'+
		'     "columnCount": 26'+
		'    }'+
		'   },'+
		'   "data": ['+
		'    {'+
		'     "rowData": ['+
		'      {'+
		'      },'+
		'      {'+
		'       "values": ['+
		'        {'+
		'        },'+
		'        {'+
		'         "userEnteredValue": {'+
		'          "numberValue": 43383'+
		'         },'+
		'         "effectiveValue": {'+
		'          "numberValue": 43383'+
		'         },'+
		'         "formattedValue": "B2 Value",'+
		'         "effectiveFormat": {'+
		'          "backgroundColor": {'+
		'           "red": 1,'+
		'           "green": 1,'+
		'           "blue": 1'+
		'          },'+
		'          "padding": {'+
		'           "top": 2,'+
		'           "right": 3,'+
		'           "bottom": 2,'+
		'           "left": 3'+
		'          },'+
		'          "horizontalAlignment": "LEFT",'+
		'          "verticalAlignment": "BOTTOM",'+
		'          "wrapStrategy": "OVERFLOW_CELL",'+
		'          "textFormat": {'+
		'           "foregroundColor": {'+
		'           },'+
		'           "fontFamily": "arial,sans,sans-serif",'+
		'           "fontSize": 10,'+
		'           "bold": false,'+
		'           "italic": false,'+
		'           "strikethrough": false,'+
		'           "underline": false'+
		'          },'+
		'          "hyperlinkDisplayType": "PLAIN_TEXT"'+
		'         }'+
		'        },'+
		'        {'+
		'         "userEnteredValue": {'+
		'          "stringValue": "C2 Value"'+
		'         },'+
		'         "effectiveValue": {'+
		'          "stringValue": "C2 Value"'+
		'         },'+
		'         "formattedValue": "C2 Value",'+
		'         "effectiveFormat": {'+
		'          "backgroundColor": {'+
		'           "red": 1,'+
		'           "green": 1,'+
		'           "blue": 1'+
		'          },'+
		'          "padding": {'+
		'           "top": 2,'+
		'           "right": 3,'+
		'           "bottom": 2,'+
		'           "left": 3'+
		'          },'+
		'          "horizontalAlignment": "LEFT",'+
		'          "verticalAlignment": "BOTTOM",'+
		'          "wrapStrategy": "OVERFLOW_CELL",'+
		'          "textFormat": {'+
		'           "foregroundColor": {'+
		'           },'+
		'           "fontFamily": "arial,sans,sans-serif",'+
		'           "fontSize": 10,'+
		'           "bold": false,'+
		'           "italic": false,'+
		'           "strikethrough": false,'+
		'           "underline": false'+
		'          },'+
		'          "hyperlinkDisplayType": "PLAIN_TEXT"'+
		'         }'+
		'        }'+
		'       ]'+
		'      },'+
		'      {'+
		'      },'+
		'      {'+
		'       "values": ['+
		'        {'+
		'        },'+
		'        {'+
		'         "userEnteredValue": {'+
		'          "stringValue": "B4 Value"'+
		'         },'+
		'         "effectiveValue": {'+
		'          "stringValue": "B4 Value"'+
		'         },'+
		'         "formattedValue": "B4 Value",'+
		'         "effectiveFormat": {'+
		'          "backgroundColor": {'+
		'           "red": 1,'+
		'           "green": 1,'+
		'           "blue": 1'+
		'          },'+
		'          "padding": {'+
		'           "top": 2,'+
		'           "right": 3,'+
		'           "bottom": 2,'+
		'           "left": 3'+
		'          },'+
		'          "horizontalAlignment": "LEFT",'+
		'          "verticalAlignment": "BOTTOM",'+
		'          "wrapStrategy": "OVERFLOW_CELL",'+
		'          "textFormat": {'+
		'           "foregroundColor": {'+
		'           },'+
		'           "fontFamily": "arial,sans,sans-serif",'+
		'           "fontSize": 10,'+
		'           "bold": false,'+
		'           "italic": false,'+
		'           "strikethrough": false,'+
		'           "underline": false'+
		'          },'+
		'          "hyperlinkDisplayType": "PLAIN_TEXT"'+
		'         }'+
		'        },'+
		'        {'+
		'         "userEnteredValue": {'+
		'          "stringValue": "C4 Value"'+
		'         },'+
		'         "effectiveValue": {'+
		'          "stringValue": "C4 Value"'+
		'         },'+
		'         "formattedValue": "C4 Value",'+
		'         "effectiveFormat": {'+
		'          "backgroundColor": {'+
		'           "red": 1,'+
		'           "green": 1,'+
		'           "blue": 1'+
		'          },'+
		'          "padding": {'+
		'           "top": 2,'+
		'           "right": 3,'+
		'           "bottom": 2,'+
		'           "left": 3'+
		'          },'+
		'          "horizontalAlignment": "LEFT",'+
		'          "verticalAlignment": "BOTTOM",'+
		'          "wrapStrategy": "OVERFLOW_CELL",'+
		'          "textFormat": {'+
		'           "foregroundColor": {'+
		'           },'+
		'           "fontFamily": "arial,sans,sans-serif",'+
		'           "fontSize": 10,'+
		'           "bold": false,'+
		'           "italic": false,'+
		'           "strikethrough": false,'+
		'           "underline": false'+
		'          },'+
		'          "hyperlinkDisplayType": "PLAIN_TEXT"'+
		'         }'+
		'        },'+
		'        {'+
		'         "userEnteredValue": {'+
		'          "stringValue": "D4 Value"'+
		'         },'+
		'         "effectiveValue": {'+
		'          "stringValue": "D4 Value"'+
		'         },'+
		'         "formattedValue": "D4 Value",'+
		'         "effectiveFormat": {'+
		'          "backgroundColor": {'+
		'           "red": 1,'+
		'           "green": 1,'+
		'           "blue": 1'+
		'          },'+
		'          "padding": {'+
		'           "top": 2,'+
		'           "right": 3,'+
		'           "bottom": 2,'+
		'           "left": 3'+
		'          },'+
		'          "horizontalAlignment": "LEFT",'+
		'          "verticalAlignment": "BOTTOM",'+
		'          "wrapStrategy": "OVERFLOW_CELL",'+
		'          "textFormat": {'+
		'           "foregroundColor": {'+
		'           },'+
		'           "fontFamily": "arial,sans,sans-serif",'+
		'           "fontSize": 10,'+
		'           "bold": false,'+
		'           "italic": false,'+
		'           "strikethrough": false,'+
		'           "underline": false'+
		'          },'+
		'          "hyperlinkDisplayType": "PLAIN_TEXT"'+
		'         }'+
		'        }'+
		'       ]'+
		'      }'+
		'     ],'+
		'     "rowMetadata": ['+
		'      {'+
		'       "pixelSize": 21'+
		'      },'+
		'      {'+
		'       "pixelSize": 21'+
		'      }' +
		'     ]'+
		'    }'+
		'   ]'+
		'  }'+
		' ],'+
		' "spreadsheetUrl": "https://docs.google.com/spreadsheets/d/1A7Td7yl6wbxGhlsjouwO-N3sRyTDq-M5p579awuYTQo/edit"'+
		'}';
		SheetsSheetResponse obj = SheetsSheetResponse.parse(json);
		System.assert(obj != null);
	}
}
