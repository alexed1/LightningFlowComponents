/*
 * Author : Sarvesh
 * Description : The component to show records of custom/standard of Object as a table.
 * Production Ready : Yes
 */
import { LightningElement, api, wire, track } from "lwc";
import getRecordData from "@salesforce/apex/HierarchyController.getRecordData";
import { getObjectInfo } from "lightning/uiObjectInfoApi";

export default class Hierarchy extends LightningElement {
  //Public Property
  @api recordId;
  @api parentField;
  @api objectName;
  @api iconName;
  @api title;
  @api colNameApi;
  @api preselectedRow = [];

  //Private Property
  @track error;
  @track gridData;
  @track soql;
  @track gridColumns = [];
  

  @wire(getObjectInfo, { objectApiName: "$objectName" })
  objectInformation({ data, error }) {
    if (data) {
      this.colNameApi.split(",").map((item) => {
        item.trim();
        this.gridColumns.push({
          label: data.fields[item].label,
          fieldName: item,
          type: "text",
        });
      });
    }
  }

  /**
   * Method : connectedCallback
   * Discription : loads one level childs case
   */
  connectedCallback() {
    this.buildSOQL();
    this.fetchRecords(this.recordId, true);
  }

  buildSOQL() {
    let cols = this.colNameApi.split(",").map((item) => item.trim());
    cols.push("Id");
    cols.push(this.parentField);
    cols = [...new Set(cols)];
    let soql = `SELECT ${cols.join(",")} FROM ${this.objectName}`;
    this.soql = soql;
  }
  /**
   * Method : handleRowToggle
   * Discription : handle row action, loads cases on click on toggle
   */
  handleRowToggle(event) {
    const rowName = event.detail.name;
    if (!event.detail.hasChildrenContent && event.detail.isExpanded) {
      this.fetchRecords(rowName, false);
    }
  }

  getSelectedName(event) {
    const selectedRows = event.detail.selectedRows;
    for (let i = 0; i < selectedRows.length; i++) {
      this.preselectedRow.push(selectedRows[i].Id);
    }
  }
  /**
   * Method : fetchRecords
   * Discription : get case data from apex
   */
  fetchRecords(parentId, onLoad) {
    getRecordData({
      soql: this.soql,
      parentField: this.parentField,
      recordId: parentId,
    })
      .then((data) => {
        if (data) {
          data = JSON.parse(JSON.stringify(data));
          let formatData = [];
          data.map((e) => {
            let obj = e.record;
            if (e["hasChildrenContent"]) {
              obj["_children"] = [];
            }
            formatData.push(obj);
          });
          if (onLoad) {
            this.gridData = formatData;
          } else {
            this.gridData = this.getNewDataWithChildren(
              parentId,
              this.gridData,
              formatData
            );
          }
        }
      })
      .catch((error) => {
        if (error) {
          this.error = "Unknown error";
          if (Array.isArray(error.body)) {
            this.error = error.body.map((e) => e.message).join(", ");
          } else if (typeof error.body.message === "string") {
            this.error = error.body.message;
          }
        }
      });
  }

  /**
   * Method : getNewDataWithChildren
   * Discription : helper method
   */
  getNewDataWithChildren(rowName, data, children) {
    return data.map((row) => {
      let hasChildrenContent = false;
      if (
        Object.prototype.hasOwnProperty.call(row, "_children") &&
        Array.isArray(row._children) &&
        row._children.length > 0
      ) {
        hasChildrenContent = true;
      }

      if (row.Id === rowName) {
        row._children = children;
      } else if (hasChildrenContent) {
        this.getNewDataWithChildren(rowName, row._children, children);
      }
      return row;
    });
  }
}
