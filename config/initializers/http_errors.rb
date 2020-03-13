ActionDispatch::ExceptionWrapper.rescue_responses.merge!('Pundit::NotAuthorizedError' => :forbidden)
