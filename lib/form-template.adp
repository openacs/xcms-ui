<div class="formtemplate">
  <noparse>
    <if \@formerror\@ not nil>
    <div class="formerror">
    Unable to process the form due the following problem(s):
    <ol>
  </noparse>
    <multiple name="elements">
      <noparse>
        <if \@formerror.@elements.id@\@ not nil>
        <li class="formerrorelement">
        <formerror id="@elements.id@">
          \@formerror.@elements.id@\@
        </formerror>
        </li>
        </if>
      </noparse>
    </multiple>
  <noparse>
    </ol>
    </div>
    </if>
  </noparse>


  <multiple name="elements">

    <if @elements.section@ not nil>
      @elements.section;noquote@
    </if>

    <group column="section">
      <if @elements.widget@ eq "hidden"> 
        <noparse><formwidget id=@elements.id@></noparse>
      </if>
      <else>
      <!-- start of none hidden element -->
        <div class="oneelement">
        <if @elements.widget@ eq "submit">
           <noparse>
             <div class="button"><formwidget id="@elements.id@"></div>
           </noparse>
        </if>
        <else>
        <!-- start of none submit element -->

           <if @elements.label@ not nil>
             <noparse>
                <if \@formerror.@elements.id@\@ not nil>
                  <label class="witherror">@elements.label;noquote@</label>
                </if>
                <else>
                  <label class="form-label">@elements.label;noquote@</label>
                </else>
              </noparse>
           </if>

           <if @elements.optional@ nil and @elements.mode@ ne "display" and @elements.widget@ ne "inform" and @elements.widget@ ne "select" and @elements.widget@ ne "hidden" and @elements.widget@ ne "submit">
             <span class="formrequired">*</span>
           </if>

           <if @elements.widget@ in radio checkbox>
             <noparse>
               <div class="formfield">
               <formgroup id="@elements.id@">
               <div class="formgroup">
                 \@formgroup.widget;noquote@
                 <label for="@elements.form_id@:elements:@elements.id@:\@formgroup.option@">
                   \@formgroup.label;noquote@
                 </label>
               </div>
               </formgroup>
               </div>
             </noparse>
           </if>
           <else>
             <noparse>
                <div class="formfield"><formwidget id="@elements.id@"></div>
             </noparse>
           </else>

   <if @elements.help_text@ not nil>
     <noparse>
       <div class="form-help-text"><strong>[i]</strong> <formhelp id="@elements.id@"></div>
     </noparse>
   </if>

        <!-- start of none submit element -->
        </else>
        </div>
      <!-- end of none hidden element -->
      </else>
    </group>
  </multiple>


</div>
