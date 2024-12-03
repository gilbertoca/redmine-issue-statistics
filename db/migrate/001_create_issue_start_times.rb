class CreateIssueStartTimes < ActiveRecord::Migration[4.2]
  def change
    create_table :issue_start_times do |t|
      t.references :issue, null: false
      t.datetime :start_datetime, null: false
    end
  end
end
