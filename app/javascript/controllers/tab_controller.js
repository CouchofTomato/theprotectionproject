import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["tab", "previousTabButton", "nextTabButton"];

  initialize() {
    this.currentTabIndex = 0;
    this.updateView();
  }

  nextTab(e) {
    e.preventDefault();
    this.currentTabIndex += 1;
    this.updateView();
  }

  previousTab(e) {
    e.preventDefault();
    this.currentTabIndex -= 1;
    this.updateView();
  }

  updateView() {
    this.showCurrentTab();
    this.showRelevantTabButtons();
  }

  showCurrentTab() {
    const tabs = this.tabTargets;
    tabs.forEach((element, index) => {
      if (index === this.currentTabIndex) {
        tabs[index].classList.remove("hidden");
      } else {
        tabs[index].classList.add("hidden");
      }
    });
  }

  showRelevantTabButtons() {
    if (this.currentTabIndex === 0) {
      this.hidePreviousTabButton();
    } else if (this.currentTabIndex === this.tabTargets.length - 1) {
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
