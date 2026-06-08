import SortableColumn from "discourse/components/topic-list/header/sortable-column";
import { withPluginApi } from "discourse/lib/plugin-api";

const CustomFieldHeaderCell = <template>
  <SortableColumn
    @sortable={{@sortable}}
    @number="false"
    @order="priority"
    @activeOrder={{@activeOrder}}
    @changeSort={{@changeSort}}
    @ascending={{@ascending}}
    @name="topic_priority.title"
  />
</template>;

const CustomFieldItemCell = <template>
  <td class="custom-field topic-list-data num">
    {{@topic.priority}}
  </td>
</template>;

export default {
  name: "topic-custom-field-intializer",
  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");
    const fieldName = siteSettings.topic_priority_field_name;

    withPluginApi((api) => {
      api.serializeOnCreate(fieldName);
      api.serializeToDraft(fieldName);
      api.serializeToTopic(fieldName, `topic.${fieldName}`);

      api.registerValueTransformer(
        "topic-list-columns",
        ({ value, context }) => {
          if (!siteSettings.topic_priority_enabled) return;

          const allowedCategories = siteSettings.topic_priority_field_categories;
          // context.category can be an object or an ID
          const categoryId = context?.category?.id || context?.category;

          if (
            categoryId &&
            allowedCategories?.length > 0 &&
            allowedCategories
              .split("|")
              .map((c) => parseInt(c, 10))
              .includes(categoryId)
          ) {
            value.add(fieldName, {
              header: CustomFieldHeaderCell,
              item: CustomFieldItemCell,
            });
          }
        }
      );
    });
  },
};
