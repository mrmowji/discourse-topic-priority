import Component from "@glimmer/component";
import { inject as controller } from "@ember/controller";
import { alias } from "@ember/object/computed";
import { service } from "@ember/service";
import { i18n } from "discourse-i18n";

export default class TopicCustomFieldTopicTitle extends Component {
  @service siteSettings;
  @controller topic;
  @alias("siteSettings.topic_priority_field_name") fieldName;

  get fieldValue() {
    return this.args.outletArgs.model.get(this.fieldName);
  }

  get categoryId() {
    return this.args.outletArgs.model?.category_id;
  }

  get isAllowedCategory() {
    return (
      this.categoryId &&
      this.siteSettings.topic_priority_field_categories
        ?.split("|")
        .map((c) => parseInt(c, 10))
        .includes(this.categoryId)
    );
  }

  <template>
    {{#unless this.topic.editingTopic}}
      {{#if this.siteSettings.topic_priority_enabled}}
        {{#if this.isAllowedCategory}}
          <span>
            {{i18n
              "topic_priority.label"
              field=this.fieldName
              value=this.fieldValue
            }}
          </span>
        {{/if}}
      {{/if}}
    {{/unless}}
  </template>
}
