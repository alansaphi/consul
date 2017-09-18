module ProposalsHelper

  def progress_bar_percentage(proposal)
    case proposal.cached_votes_up
    when 0 then 0
    when 1..Proposal.votes_needed_for_success then (proposal.total_votes.to_f * 100 / Proposal.votes_needed_for_success).floor
    else 100
    end
  end

  def supports_percentage(proposal)
    percentage = (proposal.total_votes.to_f * 100 / Proposal.votes_needed_for_success)
    case percentage
    when 0 then "0%"
    when 0..(0.1) then "0.1%"
    when (0.1)..100 then number_to_percentage(percentage, strip_insignificant_zeros: true, precision: 1)
    else "100%"
    end
  end

  def namespaced_proposal_path(proposal, options = {})
    @namespace_proposal_path ||= namespace
    case @namespace_proposal_path
    when "management"
      management_proposal_path(proposal, options)
    else
      proposal_path(proposal, options)
    end
  end

  def retire_proposals_options
    Proposal::RETIRE_OPTIONS.collect { |option| [ t("proposals.retire_options.#{option}"), option ] }
  end

  def can_create_document?
    can?(:create, @document) && @proposal.documents.size < Proposal.max_documents_allowed
  end

  def author_of_proposal?
    author_of?(@proposal, current_user)
  end

  def current_editable?
    current_user && @proposal.editable_by?(current_user)
  end

  def show_actions_menu?
    can_create_document? || author_of_proposal? || current_editable?
  end

end