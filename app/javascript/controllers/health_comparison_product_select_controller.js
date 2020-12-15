import { Controller } from "stimulus";

function productModuleCategories() {
  return [
    "core",
    "outpatient",
    "medicines_and_appliances",
    "wellness",
    "maternity",
    "dental_and_optical",
    "evacuation_and_repatriation",
  ];
}

/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["obj"] }] */

function groupProductModules(productModules) {
  return productModules.reduce((obj, productModule) => {
    obj[productModule.category] = obj[productModule.category] || [];
    obj[productModule.category].push(productModule);
    return obj;
  }, {});
}

function titleize(phrase) {
  return phrase
    .split("_")
    .map((word) => word[0].toUpperCase() + word.slice(1, word.length))
    .join(" ");
}

function productModuleRadioButtonTemplate(productModules, category) {
  return `
      <div class="field">
        <h5 class="title is-5">${titleize(category)}</h5>
        <div class="control">
          ${productModules
            .map((module) => {
              return `
              <label class="radio">
                <input class="${category}" type="radio" name="comparison_product[product_modules][${module.category}]" value="${module.id}" data-action="change->health-comparison-product-select#submitButtonCheck">
                ${module.name}
              </label>
            `;
            })
            .join("")}
        </div>
      </div>
    `;
}

export default class extends Controller {
  static targets = [
    "insurer",
    "product",
    "productModules",
    "comparisonProductSubmit",
  ];

  connect() {
    this.resetForm();
  }

  getProducts() {
    this.clearProductTarget();
    this.disableSubmitButton();
    this.clearProductModuleTarget();
    if (this.insurerTarget.value === "") return;

    const queryString = window.location.search;

    fetch(`/insurers/${this.insurerTarget.value}/products${queryString}`, {
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => this.addProductsToSelect(data));
  }

  getProductModules() {
    this.disableSubmitButton();
    this.clearProductModuleTarget();
    if (this.productTarget.value === "") return;

    fetch(`/products/${this.productTarget.value}/product_modules`, {
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => this.addProductModules(data));
  }

  addProductsToSelect(products) {
    products.forEach((product) => {
      const option = new Option(product.name, product.id);
      this.productTarget.add(option, undefined);
    });
  }

  addProductModules(productModules) {
    const groupedProductModules = groupProductModules(productModules);
    const groupedModuleCategories = Object.keys(groupedProductModules);
    const availableCategories = productModuleCategories().filter((category) =>
      groupedModuleCategories.includes(category)
    );
    const productModulesHTML = availableCategories.map((category) => {
      const categoryModules = groupedProductModules[category];
      return productModuleRadioButtonTemplate(categoryModules, category);
    });
    this.productModulesTarget.innerHTML = productModulesHTML.join("\n");
  }

  resetForm() {
    this.clearInsurerTarget();
    this.clearProductTarget();
    this.clearProductModuleTarget();
    this.disableSubmitButton();
  }

  submitButtonCheck(event) {
    if (this.submitButtonEnabled()) return;

    this.enableSubmitIfCoreModuleSelected(event.target);
  }

  submitButtonEnabled() {
    return this.comparisonProductSubmitTarget.disabled === false;
  }

  enableSubmitIfCoreModuleSelected(module) {
    if (module.classList.contains("core")) {
      this.enableSubmitButton();
    }
  }

  enableSubmitButton() {
    this.comparisonProductSubmitTarget.disabled = false;
  }

  disableSubmitButton() {
    this.comparisonProductSubmitTarget.disabled = true;
  }

  clearProductModuleTarget() {
    this.productModulesTarget.innerHTML = "";
  }

  clearInsurerTarget() {
    this.insurerTarget.value = "";
  }

  clearProductTarget() {
    this.productTarget.length = 1;
  }
}
