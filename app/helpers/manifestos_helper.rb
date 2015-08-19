module ManifestosHelper
  def current_manifesto
    @manifesto = Manifesto.where(ratified: true).last
  end
  
  def learned? tip
    learned = false
    case tip.to_sym
    when :manifesto
      if cookies[:manifesto_tip]
        learned = true
      end
    end
    return learned
  end
end
