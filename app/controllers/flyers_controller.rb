# frozen_string_literal: true

class FlyersController < ApplicationController
  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def index
    @flyers = Flyer.all
  end
end
