class Vote < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :comment
  
  def self.up_vote! obj, token
    vote = obj.votes.find_by_token(token) if obj.votes.find_by_token(token)
    if not vote
      obj.votes.create flip_state: 'up', token: token
    elsif vote.down?
      vote.update(flip_state: 'up')
    elsif vote.up?
      vote.destroy
    end
    obj.evaluate
  end
  
  def self.down_vote! obj, token
    vote = obj.votes.find_by_token(token) if obj.votes.find_by_token(token)
    if not vote
      obj.votes.create flip_state: 'down', token: token
    elsif vote.up?
      vote.update(flip_state: 'down')
    elsif vote.down?
      vote.destroy
    end
    obj.evaluate
  end
  
  def self.score obj
    up_votes_weight = 0
    for vote in obj.votes.up_votes
      # recent votes on older proposals have more weight
      up_votes_weight += ((vote.created_at.to_date - obj.created_at.to_date).to_i / 2) + 1
    end # plus one for votes on recent proposals to still get valued
    # combines up_votes, comments, and down_votes for total points
    points = (up_votes_weight + (obj.comments.size / 2)) -
      ((obj.votes.down_votes.size.to_i * 3) + (Date.today - obj.created_at.to_date).to_i / 2)
    points += obj.votes.up_votes.hotness # adds weight for clusters of votes close together in time
    points *= 3 if obj.created_at.to_datetime > 1.minutes.ago # adds more weight if just posted
    points /= 3 if obj.requires_revision? # filters revised to bottom
    return points
  end
  
  def up?
    self.flip_state.eql? 'up'
  end
  
  def down?
    self.flip_state.eql? 'down'
  end
  
  private
  
  def self.hotness
    total = 0
    for vote in self.all
      next_vote = self.all.find_by_id(vote.id + 1); if next_vote.nil? then break end
      total += 1 if (vote.created_at.to_date - next_vote.created_at.to_date).to_i.zero?
    end
    avg = total.nonzero? ? self.all.size / total : nil
    return avg ? avg : 0
  end
  
  def self.up_votes
    where flip_state: 'up'
  end
  
  def self.down_votes
    where flip_state: 'down'
  end
end
