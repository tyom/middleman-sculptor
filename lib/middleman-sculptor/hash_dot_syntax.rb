# Allow keys dot syntax
class Hash
  def method_missing(sym, *args)
    fetch(sym) { fetch(sym.to_s) { super } }
  end
end
