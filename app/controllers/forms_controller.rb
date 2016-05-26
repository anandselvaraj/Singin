class FormsController < ApplicationController

#skip_before_action :check_session,:only =>[:new,:create,:login_page,:validate_login]
 
  def index

      @form=Form.all
     
      @form = Form.paginate(:page => params[:page], :per_page => 10)
  end
 
  def new
  
      @form=Form.new
  
  end

  def create 
  
      @form=Form.new(form_params)
  #byebug
        if @form.save
         
           flash[:notice] = "Successfully created a new account..."
           
           redirect_to :action=>"index"
  
        else
  
           render "new", flash: {error: "Oops, something went wrong. Please try again"}
  
        end
  
  end

  def edit
  
      @form=Form.find params[:id]
  
  end


  def update
  
      @form=Form.find(params[:id])
  
      if @form.update_attributes(form_params)

         flash[:notice] = "Successfully updated..."
  
         redirect_to :action=>"index"
  
       else
  
          render "edit", flash: {error: "Oops, something went wrong. Please try again"}
  
       end
  
  end

def progress
 
     @form=Form.new
  
end



def import
  Form.import(params[:file])
  redirect_to root_url, notice: "File imported."
end


 
 def progress_process

    fil=params[:form][:file1]

    filename=params[:form][:file1].original_filename

    @form=Form.progress(fil)

    unless @form.blank?

    redirect_to :action=> "progress"

  else

         flash[:notice] = "Invalid file headers or file format"
         redirect_to :action=> "progress"
       end
    
  end
 
 

  def show
  
      @form = Form.find(params[:id])
      
  end

  def destroy

      @form=Form.find(params[:id])
  
      @form.delete
  
      flash[:notice] = "Successfully deleted..."

      redirect_to :action=>"index"

  end

  def login_page
  
      @form=Form.new
      
  end

  def validate_login
  
      params.permit!
  
      @form=Form.where params.permit[:form]
	
      if not @form.blank?
	   
        session[:form_id]=@form.first.id

        flash[:notice] = "Thanks for login..."
	   
        redirect_to :action =>"index"

    	else
	  
        flash[:notice] = "Invalid Email/Password Combination" if params[:email] || params[:password]

        redirect_to root_path
       
      end
  
  end


  def logout
  
      session[:form_id]=nil
  
      redirect_to root_path
  
  end


def verify_from_message
    user = get_user_for_phone_verification
    user.mark_phone_as_verified! if user

    render nothing: true
  end

  private

  def get_user_for_phone_verification
    phone_verification_code = params['Body'].try(:strip)
    phone_number            = params['From'].gsub('+1', '')

    condition = { phone_verification_code: phone_verification_code,
                  phone_number: phone_number }

    User.unverified_phones.where(condition).first
  end

  
  
  def form_params
  
      params.require(:form).permit!
      
  end

end

