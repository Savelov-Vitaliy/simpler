class TestsController < Simpler::Controller

  def index
    @params = params
  end

  def create
  end

  def show
    status 201
    render plain: "Simple text"
  end

  def list
    render 'tests/list'
    headers['Content-Type'] = 'text/plain'
  end

  private

end
