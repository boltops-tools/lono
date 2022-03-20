module Lono::Cfn::Plan::Diff
  class Data < Base
    extend Memoist

    def initialize(old, new)
      @old = old
      @new = new
    end

    def show(header_message=nil)
      changes = calculate
      if !changes && header_message
        return
      end
      logger.info header_message if header_message

      unless @added_keys.empty?
        logger.info "Added:"
        @added_keys.each do |k|
          logger.info "    #{k}: #{@new[k]}"
        end
      end
      unless @removed_keys.empty?
        logger.info "Removed:"
        @removed_keys.each do |k|
          logger.info "    #{k}: #{@old[k]}"
        end
      end
      unless @modified_keys.empty?
        logger.info "Modified:"
        @modified_keys.each do |k|
          logger.info "    #{k}: #{show_old(@old[k])} -> #{@new[k]}"
        end
      end

      unless changes
        logger.info "No changes"
      end
    end

    def show_old(v)
      if v.nil?
        '(unset)'
      elsif v == ''
        "''"
      else
        v
      end
    end

    def calculate
      @added_keys = @new.keys - @old.keys
      @removed_keys = @old.keys - @new.keys
      all_keys = (@old.keys + @new.keys).uniq
      kept_keys = all_keys - @added_keys - @removed_keys
      @modified_keys = kept_keys.select { |k| @old[k] != @new[k] }
      no_changes = @added_keys.empty? && @removed_keys.empty? && @modified_keys.empty?
      !no_changes
    end
    memoize :calculate
  end
end
