class TestsController < Simpler::Controller

  def index
    test
  end

  def create
  end

  def show
    status 201
    test
  end

  def list
    render 'tests/list'
    headers['Content-Type'] = 'text/plain'
    test
  end

  private

  def test
    @time = Time.now
    @status = response.status
    @headers = response.header
    @params = params.inspect
  end

end
