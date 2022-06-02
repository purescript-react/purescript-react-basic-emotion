import * as Emotion from '@emotion/react';

const createElement = Emotion.jsx;

export const emptyStyle = undefined;

export const emptyStyleProperty = undefined;

const flattenDataProp = (component, props) => {
  let data = null;
  if (typeof component === "string" && props._data != null) {
    data = { _data: undefined };
    Object.entries(props._data).forEach(function(entry) {
      data["data-" + entry[0]] = entry[1];
    });
  }
  return data == null ? props : Object.assign({}, props, data);
};

export const element_ = (component, props, areChildrenDynamic) => {
  const args = [component, flattenDataProp(component, props)];
  return createElement.apply(
    null,
    areChildrenDynamic || props.children == null
      ? args
      : args.concat(props.children)
  );
};

export const elementKeyed_ = (component, props) =>
  element_(component, props, true);

export const global = Emotion.Global;

export const css_ = Emotion.css;

export const important = prop => typeof prop === "string" ? prop + " !important" : prop;

export const keyframes_ = Emotion.keyframes;
