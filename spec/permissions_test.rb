def permissions_test(allowed, disallowed, action, method, object_id = false, **params)
  -> {
    describe "#{method.upcase} #{action}" do
      context 'Allowed roles' do
        allowed.each do |role|
          it "should allow #{role} to view" do
            if object_id
              if params.key? :object_id
                params[:id] = params[:object_id]
              else
                params[:id] = @object.id
              end
            end

            send method, action, params: params, session: { user_id: @users[role].id }

            expect(response).to have_http_status(params[:status] || :success)
          end
        end
      end

      context 'Disallowed roles' do
        disallowed.each do |role|
          it "should not allow #{role} to view" do
            if object_id
              if params.key? :object_id
                params[:id] = params[:object_id]
              else
                params[:id] = @object.id
              end
            end
            
            expect {
              send method, action, params: params, session: { user_id: @users[role].id }
            }.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end
    end
  }
end
