class TestsController < Simpler::Controller
  def index
    headers['Content-Type'] = 'text/plain'
  end

  def create
    render plain: 'Simple text'
  end

  def show
    status 201
  end

  def list
    render 'tests/list'
    headers['Content-Type'] = 'text/plain'
  end
end
