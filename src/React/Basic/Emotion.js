"use strict";

var Emotion = require("@emotion/core");
var createElement = Emotion.jsx;

exports.emptyStyle = undefined;

exports.emptyStyleProperty = undefined;

function flattenDataProp(component, props) {
  var data = null;
  if (typeof component === "string" && props._data != null) {
    data = { _data: undefined };
    Object.entries(props._data).forEach(function(entry) {
      data["data-" + entry[0]] = entry[1];
    });
  }
  return data == null ? props : Object.assign({}, props, data);
}

exports.element_ = function(component, props, areChildrenDynamic) {
  var args = [component, flattenDataProp(component, props)];
  return createElement.apply(
    null,
    areChildrenDynamic || props.children == null
      ? args
      : args.concat(props.children)
  );
};

exports.elementKeyed_ = function(component, props) {
  return exports.element_(component, props, true);
};

exports.global = Emotion.Global;
