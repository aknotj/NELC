class ChangeReportIdNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :reports, :subject_id, true
  end
end
