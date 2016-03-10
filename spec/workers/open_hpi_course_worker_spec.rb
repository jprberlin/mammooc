# encoding: utf-8
# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OpenHPICourseWorker do
  let!(:mooc_provider) { FactoryGirl.create(:mooc_provider, name: 'openHPI') }

  let(:open_hpi_course_worker) { described_class.new }

  let(:api_data) do
    '{
  "courses": [
    {
      "id": "c1556425-5449-4b05-97b3-42b38a39f6c5",
      "name": "Spielend Programmieren lernen 2015!",
      "abstract": "Dieser vierwöchige Kurs richtet sich an Schüler und andere Interessierte, die schon immer in die Welt des Programmierens hineinschnuppern wollten. Auf spielerische Art und Weise wird anhand der Programmiersprache Python eine Einführung in die faszinierende Welt des Programmierens und der Informationstechnologie gegeben.",
      "description": "Course Summary\r\n-----------\r\n \r\nSAP’s clients are increasingly interested in adopting cloud solutions. The prediction from IDC is that more than 65% of enterprise IT organizations will commit to hybrid cloud technologies before 2016. Companies that use SAP solutions can now choose between on-premise, cloud, and hybrid deployments – a combination of both on-premise and cloud. This freedom of choice allows companies to transform at their own pace, following their business priorities and markets, which can change at any time. \r\n \r\nIf you’re asking yourself questions like “how do I get there?”, “what does the hybrid deployment model mean for my security and operations teams?” and “how can I ensure sufficient integration between the different environments?” then this openSAP course is for you. The questions are highly company-specific, so there is no one correct answer to them all. However, the aim of this openSAP course is to give you an understanding for what running a hybrid landscape means for integration, security, and operations, and how you can start your own hybrid transformation journey. \r\n \r\nWeek 1 will provide you with an introduction to cloud and hybrid deployments.\r\n \r\nWeek 2 offers a deep dive into the topic of integration, where we will give you an overview of the different integration technologies before going on to compare them.  \r\n \r\nIn week 3, we will talk about the security aspects you should consider in order to ensure that the data in your hybrid landscape is secure.\r\n \r\nIn week 4, the focus will be on operating the new environment. How do operative tasks change when you move from an on-premise environment to a hybrid landscape? \r\n \r\nThe course concludes with week 5 – the transformation. Here, the topics of adoption, organizational impact, strategy, and roadmap will be discussed.\r\n \r\nCourse Characteristics\r\n----------------\r\n \r\n - Starting from: July 2, 2015, 09:00 UTC. ([What does this mean?][1])\r\n - Duration: 5 weeks (4 - 6 hours per week)\r\n - Final exam: August 06 – 13, 2015\r\n - Record of Achievement: after successfully completing the weekly assignments and the final exam \r\n - Course language: English\r\n - [How is an openSAP course structured?][2]\r\n \r\nCourse Content\r\n--------------\r\n \r\n - Week 1: Introduction  \r\n - Week 2: Best Practices for Integration  \r\n - Week 3: Security  \r\n - Week 4: Operations  \r\n - Week 5: Transformation – Your Next Steps  \r\n - Week 6: Final Exam  \r\n \r\nTarget Audience\r\n--------------\r\n \r\n - IT leaders and decision makers\r\n - IT architects\r\n - Technical consultants\r\n - SAP Basis and Operations teams\r\n - SAP employees\r\n \r\nCourse Requirements\r\n-------------------\r\n \r\n - Basic knowledge of the cloud paradigm and principles\r\n - Basic SAP skills\r\n \r\nDevelopment Systems\r\n-------------\r\n \r\nThis course does not require access to a development system.\r\n \r\nAbout the Instructors\r\n--------------\r\n \r\n**Rob Glickman**\r\n-------\r\n \r\n![enter image description here][3]\r\n \r\nRob Glickman is vice president of Marketing for Line of Business and Cloud Solutions at SAP, where he leads a team tasked with articulating SAP’s point of view of the business value of cloud computing, both internally within SAP as well as externally to customers, partners, and influencers. \r\n \r\nRob has close to 20 years of experience in marketing, ranging from lean startups to large enterprises.\r\n \r\nConnect with Rob on [LinkedIn][4] \r\n \r\n**Stefan Klostermann**\r\n----------------\r\n \r\n![enter image description here][11]\r\n \r\nStefan Klostermann is global head of Operations Services.  \r\n \r\nHe is responsible for the Operations Services portfolio, focusing on the SAP run phase from application lifecycle management (ALM) to application management services (AMS) for on-premise, cloud, and hybrid landscapes.\r\n\r\n \r\n**Ümit Özdurmus**\r\n--------------------\r\n \r\n![enter image description here][5]\r\n \r\nÜmit Özdurmus is the global head of SAP Security Practice, focusing on security services and customer engagements. He is responsible for end-to-end security services management, and acts as a driver and sponsor for thought leadership activities and publications.\u000b\r\n \r\nÜmit is also an SAP Mentor and key contact for the security services organization. In this capacity, he is also a member of steering committees for new products and product releases.\r\n \r\n**Maik Schmalstich**\r\n--------------\r\n \r\n![enter image description here][6]\r\n \r\nMaik Schmalstich is the global head of cloud transformation at Application & Technology Services.\r\n \r\nWith more than 12 years of experience at SAP, his focus is on advising SAP customers on the technological and architectural changes brought about by the cloud.\r\n \r\nMaik also works as a program manager for innovation projects around social media and social network business and digital transformation.\r\n \r\n**Volker Stiehl**\r\n--------------\r\n \r\n![enter image description here][7]\r\n \r\nVolker Stiehl is a chief product expert and member of the product management team for SAP Process Integration and SAP HANA Cloud Integration. \r\n \r\nHe is the author of the book “Process-Driven Applications with BPMN” and a regular speaker at various national and international conferences. Volker also lectures at the University of Erlangen-Nuremberg and the Baden-Württemberg Cooperative State University, Mosbach.\r\n \r\n \r\n\r\nAbout Further Content Experts\r\n----------------\r\n \r\n**Petra Bernhoff**\r\n---------------\r\n \r\n![enter image description here][8]\r\n \r\nPetra Bernhoff is a global program manager for cloud transformation at Application and Technology Services.  \r\n \r\nDuring her 8 years at SAP, she has guided customers in their virtualization and subsequent cloud adoption journey, and developed services and best practices to support a successful transformation to a hybrid landscape. \r\n \r\nPetra has a strong knowledge of SAP’s cloud portfolio and provides recommendations on how the solutions can be run and operated in a hybrid SAP environment. \r\n \r\n**Erik Braun**\r\n--------------------\r\n \r\n![enter image description here][9]\r\n \r\nErik Braun is a global program director in the Application and Technology Services team.  \r\n \r\nErik has an extensive international consulting and program leadership background. Over the past 14 years, he has helped companies to become more efficient in their IT and Business processes.  During his 5 years at SAP, he has lead the Global Architect program, helping architects to achieve a common framework of understanding, move into a cloud mindset, and support companies as they transform. \r\n \r\nErik designs and develops role-based curricula to guide companies on their journey towards a more productive and networked environment.\r\n \r\n**Janusz Smilek**\r\n----------------\r\n \r\n![enter image description here][10]\r\n \r\nJanusz Smilek is a chief product expert and solution architect for integration rapid-deployment solutions and best practices, focusing on on-premise-to-cloud and cloud-to-cloud integration. In his current role, Janusz has worked on various integration scenarios for SAP Business Suite with SuccessFactors, SAP Business Suite with the Ariba Network, and other SAP cloud products.\r\n \r\n\r\n\r\n\r\n  [1]: https://open.hpi.de/pages/faq#how-is-an-opensap-course-structured?\r\n  [2]: https://open.hpi.de/pages/faq#how-is-an-opensap-course-structured?\r\n  [3]: /files/d5a6ff71-e653-4978-b6ae-0dbccc52f5e7\r\n  [4]: https://www.linkedin.com/profile/public-profile-settings?trk=prof-edit-edit-public_profile/ \"EXTERNAL\"\r\n  [5]: /files/faea6515-1670-4b42-84d8-4df528044b71\r\n  [6]: /files/807ffae3-ef4b-4aca-a34e-b7cfdabebe12\r\n  [7]: /files/d890fa81-ac6c-4866-84d5-f067f289a495\r\n  [8]: /files/9e96200d-572a-41a3-829c-c95e9ca31839\r\n  [9]: /files/ecc52159-8e66-47a5-bdbf-31799ed8b5d2\r\n  [10]: /files/91ecee12-3bd5-4448-a95e-2b8cfc41c734\r\n  [11]: /files/9c4d5fa9-751d-4a20-9ba2-1882e0328d81",
      "language": "de",
      "channel": null,
      "categories": [
        "e134a8e8-e0b4-4e58-8d80-7a5325ca2793"
      ],
      "teachers": [
        "8006a5c9-1085-4f15-a501-c2e63876ca94",
        "c39f572d-45a6-4bcb-953d-958ae1cc7f31"
      ],
      "teachersLabel": "",
      "image": "/files/fca875a9-d935-4b56-8080-5279b9ef9b54?name=",
      "status": "active",
      "startDate": "2015-11-09T08:00:00Z",
      "endDate": "2015-12-07T22:30:00Z",
      "displayStartDate": "2015-11-09T08:00:00Z",
      "isHidden": false,
      "isInviteOnly": false,
      "isExternal": false,
      "externalCourseUrl": "",
      "urls": {
        "details": "/courses/pythonjunior2015",
        "resume": "/courses/pythonjunior2015/resume",
        "enroll": "/enrollments?course_id=pythonjunior2015",
        "progress": "/courses/pythonjunior2015/progress"
      }
    }
  ],
  "teachers": [
    {
      "id": "8006a5c9-1085-4f15-a501-c2e63876ca94",
      "name": "Prof. Hasso Plattner"
    },
    {
      "id": "c39f572d-45a6-4bcb-953d-958ae1cc7f31",
      "name": "Prof. Dr. Martin v. Löwis"
    }
  ]
}'
  end

  let(:json_api_data) do
    JSON.parse api_data
  end

  let(:html_course_description) do
    '<h2>Course Summary</h2>

<p>SAP’s clients are increasingly interested in adopting cloud solutions. The prediction from IDC is that more than 65% of enterprise IT organizations will commit to hybrid cloud technologies before 2016. Companies that use SAP solutions can now choose between on-premise, cloud, and hybrid deployments – a combination of both on-premise and cloud. This freedom of choice allows companies to transform at their own pace, following their business priorities and markets, which can change at any time. </p>

<p>If you’re asking yourself questions like “how do I get there?”, “what does the hybrid deployment model mean for my security and operations teams?” and “how can I ensure sufficient integration between the different environments?” then this openSAP course is for you. The questions are highly company-specific, so there is no one correct answer to them all. However, the aim of this openSAP course is to give you an understanding for what running a hybrid landscape means for integration, security, and operations, and how you can start your own hybrid transformation journey. </p>

<p>Week 1 will provide you with an introduction to cloud and hybrid deployments.</p>

<p>Week 2 offers a deep dive into the topic of integration, where we will give you an overview of the different integration technologies before going on to compare them.  </p>

<p>In week 3, we will talk about the security aspects you should consider in order to ensure that the data in your hybrid landscape is secure.</p>

<p>In week 4, the focus will be on operating the new environment. How do operative tasks change when you move from an on-premise environment to a hybrid landscape? </p>

<p>The course concludes with week 5 – the transformation. Here, the topics of adoption, organizational impact, strategy, and roadmap will be discussed.</p>

<h2>Course Characteristics</h2>

<ul>
<li>Starting from: July 2, 2015, 09:00 UTC. (<a href="https://open.hpi.de/pages/faq#how-is-an-opensap-course-structured?">What does this mean?</a>)</li>
<li>Duration: 5 weeks (4 - 6 hours per week)</li>
<li>Final exam: August 06 – 13, 2015</li>
<li>Record of Achievement: after successfully completing the weekly assignments and the final exam </li>
<li>Course language: English</li>
<li><a href="https://open.hpi.de/pages/faq#how-is-an-opensap-course-structured?">How is an openSAP course structured?</a></li>
</ul>

<h2>Course Content</h2>

<ul>
<li>Week 1: Introduction<br>
</li>
<li>Week 2: Best Practices for Integration<br>
</li>
<li>Week 3: Security<br>
</li>
<li>Week 4: Operations<br>
</li>
<li>Week 5: Transformation – Your Next Steps<br>
</li>
<li>Week 6: Final Exam<br>
</li>
</ul>

<h2>Target Audience</h2>

<ul>
<li>IT leaders and decision makers</li>
<li>IT architects</li>
<li>Technical consultants</li>
<li>SAP Basis and Operations teams</li>
<li>SAP employees</li>
</ul>

<h2>Course Requirements</h2>

<ul>
<li>Basic knowledge of the cloud paradigm and principles</li>
<li>Basic SAP skills</li>
</ul>

<h2>Development Systems</h2>

<p>This course does not require access to a development system.</p>

<h2>About the Instructors</h2>

<h2><strong>Rob Glickman</strong></h2>

<p><img src="https://open.hpi.de/files/d5a6ff71-e653-4978-b6ae-0dbccc52f5e7" alt="enter image description here"></p>

<p>Rob Glickman is vice president of Marketing for Line of Business and Cloud Solutions at SAP, where he leads a team tasked with articulating SAP’s point of view of the business value of cloud computing, both internally within SAP as well as externally to customers, partners, and influencers. </p>

<p>Rob has close to 20 years of experience in marketing, ranging from lean startups to large enterprises.</p>

<p>Connect with Rob on <a href="https://www.linkedin.com/profile/public-profile-settings?trk=prof-edit-edit-public_profile/" title="EXTERNAL">LinkedIn</a> </p>

<h2><strong>Stefan Klostermann</strong></h2>

<p><img src="https://open.hpi.de/files/9c4d5fa9-751d-4a20-9ba2-1882e0328d81" alt="enter image description here"></p>

<p>Stefan Klostermann is global head of Operations Services.  </p>

<p>He is responsible for the Operations Services portfolio, focusing on the SAP run phase from application lifecycle management (ALM) to application management services (AMS) for on-premise, cloud, and hybrid landscapes.</p>

<h2><strong>Ümit Özdurmus</strong></h2>

<p><img src="https://open.hpi.de/files/faea6515-1670-4b42-84d8-4df528044b71" alt="enter image description here"></p>

<p>Ümit Özdurmus is the global head of SAP Security Practice, focusing on security services and customer engagements. He is responsible for end-to-end security services management, and acts as a driver and sponsor for thought leadership activities and publications.</p>

<p>Ümit is also an SAP Mentor and key contact for the security services organization. In this capacity, he is also a member of steering committees for new products and product releases.</p>

<h2><strong>Maik Schmalstich</strong></h2>

<p><img src="https://open.hpi.de/files/807ffae3-ef4b-4aca-a34e-b7cfdabebe12" alt="enter image description here"></p>

<p>Maik Schmalstich is the global head of cloud transformation at Application &amp; Technology Services.</p>

<p>With more than 12 years of experience at SAP, his focus is on advising SAP customers on the technological and architectural changes brought about by the cloud.</p>

<p>Maik also works as a program manager for innovation projects around social media and social network business and digital transformation.</p>

<h2><strong>Volker Stiehl</strong></h2>

<p><img src="https://open.hpi.de/files/d890fa81-ac6c-4866-84d5-f067f289a495" alt="enter image description here"></p>

<p>Volker Stiehl is a chief product expert and member of the product management team for SAP Process Integration and SAP HANA Cloud Integration. </p>

<p>He is the author of the book “Process-Driven Applications with BPMN” and a regular speaker at various national and international conferences. Volker also lectures at the University of Erlangen-Nuremberg and the Baden-Württemberg Cooperative State University, Mosbach.</p>

<h2>About Further Content Experts</h2>

<h2><strong>Petra Bernhoff</strong></h2>

<p><img src="https://open.hpi.de/files/9e96200d-572a-41a3-829c-c95e9ca31839" alt="enter image description here"></p>

<p>Petra Bernhoff is a global program manager for cloud transformation at Application and Technology Services.  </p>

<p>During her 8 years at SAP, she has guided customers in their virtualization and subsequent cloud adoption journey, and developed services and best practices to support a successful transformation to a hybrid landscape. </p>

<p>Petra has a strong knowledge of SAP’s cloud portfolio and provides recommendations on how the solutions can be run and operated in a hybrid SAP environment. </p>

<h2><strong>Erik Braun</strong></h2>

<p><img src="https://open.hpi.de/files/ecc52159-8e66-47a5-bdbf-31799ed8b5d2" alt="enter image description here"></p>

<p>Erik Braun is a global program director in the Application and Technology Services team.  </p>

<p>Erik has an extensive international consulting and program leadership background. Over the past 14 years, he has helped companies to become more efficient in their IT and Business processes.  During his 5 years at SAP, he has lead the Global Architect program, helping architects to achieve a common framework of understanding, move into a cloud mindset, and support companies as they transform. </p>

<p>Erik designs and develops role-based curricula to guide companies on their journey towards a more productive and networked environment.</p>

<h2><strong>Janusz Smilek</strong></h2>

<p><img src="https://open.hpi.de/files/91ecee12-3bd5-4448-a95e-2b8cfc41c734" alt="enter image description here"></p>

<p>Janusz Smilek is a chief product expert and solution architect for integration rapid-deployment solutions and best practices, focusing on on-premise-to-cloud and cloud-to-cloud integration. In his current role, Janusz has worked on various integration scenarios for SAP Business Suite with SuccessFactors, SAP Business Suite with the Ariba Network, and other SAP cloud products.</p>
'
  end

  let(:categories_data) do
    '{
        "categories": [
            {
                "id": "e134a8e8-e0b4-4e58-8d80-7a5325ca2793",
                "name": "openHPI Junior",
                "description": null
            }
        ]
    }'
  end

  let(:json_categories_data) do
    JSON.parse categories_data
  end

  let(:teachers_hash) do
    {'8006a5c9-1085-4f15-a501-c2e63876ca94' => 'Prof. Hasso Plattner', 'c39f572d-45a6-4bcb-953d-958ae1cc7f31' => 'Prof. Dr. Martin v. Löwis'}
  end

  let(:categories_hash) do
    {'e134a8e8-e0b4-4e58-8d80-7a5325ca2793' => 'openHPI Junior'}
  end

  let!(:course_track_type) { FactoryGirl.create :course_track_type, type_of_achievement: 'xikolo_record_of_achievement' }

  it 'delivers MOOCProvider' do
    expect(open_hpi_course_worker.mooc_provider).to eql mooc_provider
  end

  it 'gets an API courses response' do
    expect(open_hpi_course_worker.course_data).not_to be_nil
  end

  it 'gets an API categories response' do
    expect(open_hpi_course_worker.prepare_categories_hash).not_to be_nil
  end

  it 'loads new course into database' do
    course_count = Course.count
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/categories', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(categories_data)
    open_hpi_course_worker.handle_response_data json_api_data
    expect(course_count).to eql Course.count - 1
  end

  it 'loads course attributes into database' do
    open_hpi_course_worker.handle_response_data json_api_data
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/categories', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(categories_data)

    json_course = json_api_data['courses'][0]
    course = Course.find_by(provider_course_id: json_course['id'], mooc_provider_id: mooc_provider.id)

    expect(course.name).to eql json_course['name']
    expect(course.provider_course_id).to eql json_course['id']
    expect(course.mooc_provider_id).to eql mooc_provider.id
    expect(course.url).to include json_course['urls']['details']
    expect(course.language).to eql json_course['language']
    expect(course.start_date).to eql Time.zone.parse(json_course['displayStartDate'])
    expect(course.end_date).to eql Time.zone.parse(json_course['endDate'])
    # expect(course.description).to eql html_course_description
    expect(course.course_instructors).to eql 'Prof. Hasso Plattner, Prof. Dr. Martin v. Löwis'
    expect(course.categories).to match_array ['openHPI Junior']
    expect(course.open_for_registration).to eql json_course['status'] == 'active' || json_course[''] == 'archive'
    expect(course.tracks[0].costs).to eql 0.0
    expect(course.tracks[0].credit_points).to be_nil
    expect(course.tracks[0].track_type.type_of_achievement).to eql course_track_type.type_of_achievement
    expect(course.tracks[0].costs).to eql 0.0
    expect(course.tracks[0].costs_currency).to eql "\xe2\x82\xac"
  end

  it 'loads courses on perform' do
    expect_any_instance_of(described_class).to receive(:load_courses)
    Sidekiq::Testing.inline!
    described_class.perform_async
  end

  it 'does load courses and handle the response correctly' do
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/courses', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(api_data)
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/categories', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(categories_data)
    expect_any_instance_of(described_class).to receive(:handle_response_data).with(json_api_data)
    open_hpi_course_worker.load_courses
  end

  it 'does not duplicate courses' do
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/courses', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(api_data)
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/categories', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(categories_data)
    open_hpi_course_worker.load_courses
    expect { open_hpi_course_worker.load_courses }.to change { Course.count }.by(0)
  end

  it 'handles an empty API response' do
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/courses', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return('{"courses": [],"teachers": []}')
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/categories', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(categories_data)
    expect { open_hpi_course_worker.load_courses }.to change { Course.count }.by(0)
  end

  it 'does not parse an empty string' do
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/courses', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return('')
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/categories', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(categories_data)
    expect { open_hpi_course_worker.course_data }.not_to raise_error
    expect(open_hpi_course_worker.course_data).to eql []
  end

  it 'prepares a correct teachers hash' do
    puts open_hpi_course_worker.prepare_teachers_hash(json_api_data['teachers'])
    expect(open_hpi_course_worker.prepare_teachers_hash(json_api_data['teachers'])).to eql teachers_hash
  end

  it 'prepares a correct categories hash' do
    allow(RestClient).to receive(:get).with('https://open.hpi.de/api/v2/categories', accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"').and_return(categories_data)
    puts open_hpi_course_worker.prepare_categories_hash
    expect(open_hpi_course_worker.prepare_categories_hash).to eql categories_hash
  end

  it 'translates teachers hash' do
    expect(open_hpi_course_worker.translate_teachers(['8006a5c9-1085-4f15-a501-c2e63876ca94'], teachers_hash)).to eql 'Prof. Hasso Plattner'
  end

  it 'translates more than one teacher' do
    expect(open_hpi_course_worker.translate_teachers(['8006a5c9-1085-4f15-a501-c2e63876ca94', 'c39f572d-45a6-4bcb-953d-958ae1cc7f31'], teachers_hash)).to eql 'Prof. Hasso Plattner, Prof. Dr. Martin v. Löwis'
  end

  it 'translates categories' do
    expect(open_hpi_course_worker.translate_categories(['e134a8e8-e0b4-4e58-8d80-7a5325ca2793'], categories_hash)).to eql ['openHPI Junior']
  end
end
