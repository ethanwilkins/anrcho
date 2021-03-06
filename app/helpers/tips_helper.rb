module TipsHelper
  def learned? tip
    learned = false
    case tip.to_sym
    when :manifesto
      if cookies[:manifesto_tip].present?
        learned = true
      end
    end
    return learned
  end
end
