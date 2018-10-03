USER_KEYS = %w(
  id
  email
  first_name
  last_name
  profile_image_url
  state
  role
  entries
  expenses
  created_at
  updated_at
  url
  entries_url
  expenses_url
  activate_url
  deactivate_url
  give_access_to_projects_url
  revoke_access_to_projects_url
  revoke_access_to_all_projects_url
).freeze

USER_API_REPLACE_VALUES = {
  id: /\"id\":(.*?),/mi,
  mail: /\"email\":\"(.*?)\"/mi,
  first_name: /\"first_name\":\"(.*?)\"/mi,
  last_name: /\"last_name\":\"(.*?)\"/mi,
  profile_image_url: /\"profile_image_url\":\"(.*?)\"/i,
  url: /\"url\":\"(.*?)\"/mi,
  entries_url: /\"entries_url\":\"(.*?)\"/mi,
  expanses_url: /\"expanse_url\":\"(.*?)\"/mi,
  activate_url: /\"activate_url\":\"(.*?)\"/mi,
  deactivate_url: /\"deactivate_url\":\"(.*?)\"/mi,
  access_projects_url: /\"give_access_to_projects_url\":\"(.*?)\"/mi,
  revoke_projects_url: /\"revoke_access_to_projects_url\":\"(.*?)\"/mi,
  revoke_all_projects_url: /\"revoke_access_to_all_projects_url\":\"(.*?)\"/mi
}.freeze
