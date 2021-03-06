class RootEntry < DirectoryEntry

  def self.instance
    RootEntry.first || RootEntry.create!
  end

  def full_path
    ""
  end

  protected
    def root?
      true
    end

    def valdate_parent
      errors.add(:parent, :must_be_nil) unless parent == nil
    end
end

# == Schema Information
#
# Table name: entries
#
#  id                  :integer          not null, primary key
#  type                :string(255)
#  name                :text
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  file_uid            :text
#  file_size           :integer
#  file_width          :integer
#  file_height         :integer
#  file_mime_type      :string(255)
#  file_mime_directory :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

