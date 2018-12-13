({
    init : function(cmp, event, helper) {
        
        var name="$Resource." + cmp.get("v.imageName");
        cmp.set("v.imageSourceString", $A.get(name)); 
        if(cmp.get("v.imageNameHover") == ""){
            cmp.set("v.imageNameHover", cmp.get("v.imageName"))
        }
        if(cmp.get("v.imageNamePress") == ""){
            cmp.set("v.imageNamePress", cmp.get("v.imageNameHover"))
        }        
        helper.validateFlowNavigationInputs(cmp);
        
        var styleText = "";       
        styleText=styleText + "border-radius:" + cmp.get("v.styleBorderRadius") + ";";
        styleText=styleText + "border-style:" + cmp.get("v.styleBorderStyle") + ";";
        styleText=styleText + "border-width:" + cmp.get("v.styleBorderWidth") + ";";
        styleText=styleText + "border-color:" + cmp.get("v.styleBorderColor") + ";";
        
        styleText=styleText + "margin-top:" + cmp.get("v.styleMarginTop") + ";";
        styleText=styleText + "margin-right:" + cmp.get("v.styleMarginRight") + ";";
        styleText=styleText + "margin-bottom:" + cmp.get("v.styleMarginBottom") + ";";
        styleText=styleText + "margin-left:" + cmp.get("v.styleMarginLeft") + ";";
        styleText=styleText + "margin:" + cmp.get("v.styleMargin") + ";";
        
        styleText=styleText + "padding-top:" + cmp.get("v.stylePaddingTop") + ";";
        styleText=styleText + "padding-right:" + cmp.get("v.stylePaddingRight") + ";";
        styleText=styleText + "padding-bottom:" + cmp.get("v.stylePaddingBottom") + ";";
        styleText=styleText + "padding-left:" + cmp.get("v.stylePaddingLeft") + ";";      
        
        styleText=styleText + "width:" + cmp.get("v.styleWidth") + ";height:" + cmp.get("v.styleHeight") + ";";
        styleText=styleText + "max-width:" + cmp.get("v.styleMaxWidth") + ";max-height:" + cmp.get("v.styleMaxHeight") + ";";  
        
        //normally the use of span elements instead of div elements in the markup
        //enables images to flow on the same screen.
        //sometimes, though, you want to use the entire width and do things like centering.
        //by setting this flag, the image span gets treated as a full-width block
        if(cmp.get("v.styleAsBlockFlag") == "true")
            styleText=styleText + "display:block;";
        
        cmp.set("v.styleText", styleText);
        
    },
    
    handleClick : function(cmp, event, helper) {
        helper.navigateFlow(cmp,helper);
        cmp.set("v.fire", true);
    },
    
    handleMouseOver : function(cmp, event, helper) {
        var name="$Resource." + cmp.get("v.imageNameHover");
        cmp.set("v.imageSourceString", $A.get(name));     
    },
    
    handleMouseOut : function(cmp, event, helper) {
        var name="$Resource." + cmp.get("v.imageName");
        cmp.set("v.imageSourceString", $A.get(name));     
    },
    
    handleMouseDown : function(cmp, event, helper) {
        var name="$Resource." + cmp.get("v.imageNamePress");
        cmp.set("v.imageSourceString", $A.get(name));     
    },
    
    handleMouseUp : function(cmp, event, helper) {
        var name="$Resource." + cmp.get("v.imageNameHover");
        cmp.set("v.imageSourceString", $A.get(name));     
    },
})
