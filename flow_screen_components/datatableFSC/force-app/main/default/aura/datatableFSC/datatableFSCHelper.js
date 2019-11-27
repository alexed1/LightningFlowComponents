({
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.mydata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.mydata", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    updateEditedValues: function(cmp, event) {
        var keyField = cmp.get("v.keyField");
        var data = cmp.get("v.mydata");
        var drafts = event.getParam('draftValues');

        // apply drafts to mydata
        data = data.map(item => {
            let draft = drafts.find(d => d[keyField] == item[keyField]);

            if (draft != undefined) {
                let fieldNames = Object.keys(draft);
                fieldNames.forEach(el => item[el] = draft[el]);
            }

            return item;
        });

        cmp.set("v.mydata", data);
    }
})
