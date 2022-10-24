// singleton class to share data between components
const _data = {};

// returns unique index for requesting component
function getIndex() {
  // Keep a separate index counter so each component can have its own index
  if (!_data.ctr) {
    _data.ctr = [];
  }
  if (!_data.arr) {
    _data.arr = [];
  }
  if (!_data.valid) {
    _data.valid = [];
  }
  let index = _data.ctr.length;
  _data.ctr.push(null);
  return index;
}

function setItem(index, value) {
  _data.arr[index] = value;
}

function getItem(index) {
  return _data.arr ? _data.arr[index] : null;
}

function getArr() {
  return _data.arr;
}

function setArr(value) {
  _data.arr = value;
  if (value.length > 0) {
    _data.valid = Array(value.length).fill(false);
  }
}

function setValid(index, isValid) {
  _data.valid[index] = isValid;
  console.log("setValid", _data.valid);
}

function getAllValid() {
  // make sure all elements are valid
  return !_data.valid.includes(false);
}

function reset() {
  _data.ctr = [];
  _data.arr = [];
  _data.valid = [];
}

export {
  getIndex,
  setItem,
  getItem,
  getArr,
  setArr,
  reset,
  setValid,
  getAllValid
};