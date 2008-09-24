class FixDucksRingedAndDucksFoundFileFormat < ActiveRecord::Migration

  def self.up
    # Warning this script does not terminate on error, so keep an eye on the output.
    print "Bash script will fix file format of ringed and found ducks files..."
    if (!system "sh db/migrate/bash/fix_ducks_ringed_found_file_format.sh " + DUCKS_RINGED_FILE + " " + DUCKS_RECAPTURED_FILE) then fail end
  
  end

  def self.down
    # Should clean up output file.
  end
end
