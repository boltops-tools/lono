class Lono::CLI
  class Completion < Base
    desc "script", "generates script that can be eval to setup auto-completion"
    long_desc Help.text("completion:script")
    def script
      Completer::Script.generate
    end

    desc "completions *PARAMS", "prints words for auto-completion"
    long_desc Help.text("completion:list")
    def list(*params)
      Completer.new(*params).run
    end
  end
end
