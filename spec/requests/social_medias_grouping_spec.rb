require 'rails_helper'

describe 'social medias grouping' do
  let(:tweets) do
    [{
      'username' => '@GuyEndoreKaiser',
      'tweet' => 'If you live to be 100, you should make up some fake reason why, just to mess with people... '\
                 'like claim you ate a pinecone every single day.'
    }]
  end
  let(:statuses) do
    [{
      'name' => 'Some Friend',
      'status' => "Here's some photos of my holiday. Look how much more fun I'm having than you are!"
    }]
  end
  let(:photos) do
    [{
      'username' => 'hipster1',
      'picture' => 'food'
    }]
  end

  it 'groups social media updates from Take Home API' do
    [['/twitter', tweets], ['/facebook', statuses], ['/instagram', photos]].each do |path, records|
      stub_request(:get, take_home_url(path)).to_return(status: 200, body: records.to_json)
    end

    get root_path

    expect(JSON.parse(response.body)).to eq('twitter' => tweets, 'facebook' => statuses, 'instagram' => photos)
  end

  it 'retries when an error happens' do
    [['/twitter', tweets], ['/facebook', statuses], ['/instagram', photos]].each do |path, records|
      stub_request(:get, take_home_url(path)). \
        to_return(status: 500, body: 'I am trapped in a social media factory send help').then. \
        to_return(status: 200, body: records.to_json)
    end

    get root_path

    expect(JSON.parse(response.body)).to eq('twitter' => tweets, 'facebook' => statuses, 'instagram' => photos)
  end

  it 'returns empty arrays for unavailable services' do
    %w[/twitter /facebook /instagram].each do |path|
      stub_request(:get, take_home_url(path)). \
        to_return(status: 500, body: 'I am trapped in a social media factory send help').then. \
        to_return(status: 500, body: 'I am trapped in a social media factory send help').then. \
        to_return(status: 500, body: 'I am trapped in a social media factory send help').then. \
        to_return(status: 500, body: 'I am trapped in a social media factory send help').then. \
        to_return(status: 500, body: 'I am trapped in a social media factory send help').then. \
        to_return(status: 500, body: 'I am trapped in a social media factory send help')
    end

    get root_path

    expect(JSON.parse(response.body)).to eq('twitter' => [], 'facebook' => [], 'instagram' => [])
  end
end
