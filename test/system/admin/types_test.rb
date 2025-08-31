require "application_system_test_case"

class Admin::TypesTest < ApplicationSystemTestCase
  setup do
    @admin_type = admin_types(:one)
  end

  test "visiting the index" do
    visit admin_types_url
    assert_selector "h1", text: "Types"
  end

  test "should create type" do
    visit admin_types_url
    click_on "New type"

    fill_in "Description", with: @admin_type.description
    fill_in "Name", with: @admin_type.name
    click_on "Create Type"

    assert_text "Type was successfully created"
    click_on "Back"
  end

  test "should update Type" do
    visit admin_type_url(@admin_type)
    click_on "Edit this type", match: :first

    fill_in "Description", with: @admin_type.description
    fill_in "Name", with: @admin_type.name
    click_on "Update Type"

    assert_text "Type was successfully updated"
    click_on "Back"
  end

  test "should destroy Type" do
    visit admin_type_url(@admin_type)
    accept_confirm { click_on "Destroy this type", match: :first }

    assert_text "Type was successfully destroyed"
  end
end
