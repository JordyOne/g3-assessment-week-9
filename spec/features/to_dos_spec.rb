feature "ToDos" do
  scenario "A user can sign in a create a ToDo" do

    visit "/"

    click_link "Register"

    fill_in "Username", with: "hunta"
    fill_in "Password", with: "pazzword"

    click_button "Register"

    fill_in "Username", with: "hunta"
    fill_in "Password", with: "pazzword"

    click_button "Sign In"

    expect(page).to have_content "Welcome, hunta"

    fill_in "What do you need to do?", with: "Get a haircut"
    click_button "Add ToDo"

    expect(page).to have_content "ToDo added"

    within ".todos" do
      expect(page).to have_content "Get a haircut"
    end
  end

  feature "To-Do"
  scenario "A user can edit a ToDo" do

    visit "/"

    click_link "Register"

    fill_in "Username", with: "hunta"
    fill_in "Password", with: "pazzword"

    click_button "Register"

    fill_in "Username", with: "hunta"
    fill_in "Password", with: "pazzword"

    click_button "Sign In"

    expect(page).to have_content "Welcome, hunta"

    fill_in "What do you need to do?", with: "Get a haircut"
    click_button "Add ToDo"

    expect(page).to have_content "ToDo added"

    click_on "Edit"

    expect(page).to have_content("What do you need to do?")

    fill_in "What do you need to do?", with: "I have changed the message"

    click_on "Update ToDo"

    expect(page).to have_content("I have changed the message")
    expect(page).to have_content("ToDo Updated")

  end
end
