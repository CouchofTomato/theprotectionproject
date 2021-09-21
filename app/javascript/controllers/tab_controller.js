import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["tab", "previousTabButton", "nextTabButton"];
  static values = { index: Number };

  initialize() {
    this.updateView();
  }

  nextTab(e) {
    e.preventDefault();
    this.indexValue++
    this.updateView();
  }

  previousTab(e) {
    e.preventDefault();
    this.indexValue--
    this.updateView();
  }

  updateView() {
    this.showCurrentTab();
    this.showRelevantTabButtons();
  }

  showCurrentTab() {
    const tabs = this.tabTargets;
    tabs.forEach((element, index) => {
      if (index === this.indexValue) {
        tabs[index].classList.remove("hidden");
      } else {
        tabs[index].classList.add("hidden");
      }
    });
  }

  showRelevantTabButtons() {
    if (this.indexValue === 0) {
      this.hidePreviousTabButton();
    } else if (this.indexValue === this.tabTargets.length - 1) {
      this.hideNextTabButton();
    } else {
      this.showPreviousTabButton();
      this.showNextTabButton();
    }
  }

  hidePreviousTabButton() {
    this.previousTabButtonTarget.classList.add("invisible");
  }

  hideNextTabButton() {
    this.nextTabButtonTarget.classList.add("invisible");
  }

  showPreviousTabButton() {
    this.previousTabButtonTarget.classList.remove("invisible");
  }

  showNextTabButton() {
    this.nextTabButtonTarget.classList.remove("invisible");
  }
}
