module ObjectExtensions
  refine Object do
    def blank?
      respond_to?(:empty?) ? empty? : !self
    end
  end
end
