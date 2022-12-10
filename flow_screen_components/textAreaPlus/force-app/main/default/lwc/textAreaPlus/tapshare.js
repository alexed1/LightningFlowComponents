// singleton class to share data between components
const _data = {};

// returns unique index for requesting component
function getIndex() {
  // Keep a separate index counter so each component can have its own index
  // Counter needs to be reset, but array needs to persist
  if (!_data.ctr) {
    _data.ctr = [];
  }
  if (!_data.arr) {
    _data.arr = [];
  }
  if (!_data.valid) {
    _data.valid = [];
  }

  const index = _data.ctr.length;
  _data.ctr.push(null);

  // fill the array with nulls to make sure it matches the number of elements
  if (index >= _data.arr.length) {
    _data.arr.push(null);
  }

  return index;
}

function isMaxIndex(index) {
  return index === _data.arr.length - 1;
}

function setItem(index, value) {
  _data.arr[index] = value;
}

function getItem(index) {
  if (_data.arr?.length > index) {
    return _data.arr ? _data.arr[index] : null;
  } else return null;
}

function getArr() {
  return _data.arr;
}

function setValid(index, isValid) {
  _data.valid[index] = isValid;
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

function resetCounter() {
  _data.ctr = [];
}

function resetValidation() {
  _data.valid = [];
}

export {
  isMaxIndex,
  getIndex,
  setItem,
  getItem,
  getArr,
  reset,
  setValid,
  getAllValid,
  resetValidation,
  resetCounter
};