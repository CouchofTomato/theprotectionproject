import { Controller } from "stimulus";

function selectedProductQueryString(dataParams) {
  return Object.entries(dataParams)
    .map(([key, val]) => {
      if (Array.isArray(val)) {
        const productModules = val.map(
          (val2) => `selected_products[][${key}][]=${val2}`
        );
        return encodeURI(productModules.join("&"));
      }
      return encodeURI(`selected_products[][${key}]=${val}`);
    })
    .join("&");
}

export default class extends Controller {
  static targets = ["option", "productDetailsJSON", "productDetailJSON"];

  excelExport() {
    const url = `/comparisons/show.xlsx?${this.parameterise()}`;
    window.location = url;
  }

  parameterise() {
    return [this.selectedProductParameters(), this.optionParameters()].join(
      "&"
    );
  }

  selectedProductParameters() {
    return this.productDetailJSONTargets
      .map((target) => {
        const dataParams = JSON.parse(target.dataset.productDetails);
        return selectedProductQueryString(dataParams);
      })
      .join("&");
  }

  optionParameters() {
    return this.selectedOptions()
      .map((option) => `options[]=${option}`)
      .join("&");
  }

  selectedOptions() {
    return this.optionTargets
      .filter((option) => option.checked)
      .map((option) => option.value);
  }
}
