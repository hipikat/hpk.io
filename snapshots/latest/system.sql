--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: wagtail
--

COPY public.auth_group (id, name) FROM stdin;
1	Moderators
2	Editors
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: wagtail
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	wagtailcore	page
2	wagtailimages	image
3	wagtailcore	groupapprovaltask
4	wagtailcore	locale
5	wagtailcore	site
6	wagtailcore	modellogentry
7	wagtailcore	collectionviewrestriction
8	wagtailcore	collection
9	wagtailcore	groupcollectionpermission
10	wagtailcore	uploadedfile
11	wagtailcore	referenceindex
12	wagtailcore	revision
13	wagtailcore	grouppagepermission
14	wagtailcore	pageviewrestriction
15	wagtailcore	workflowpage
16	wagtailcore	workflowcontenttype
17	wagtailcore	workflowtask
18	wagtailcore	task
19	wagtailcore	workflow
20	wagtailcore	workflowstate
21	wagtailcore	taskstate
22	wagtailcore	pagelogentry
23	wagtailcore	comment
24	wagtailcore	commentreply
25	wagtailcore	pagesubscription
26	wagtailadmin	admin
27	wagtaildocs	document
28	picata	articletype
29	picata	basicpage
30	picata	homepage
31	picata	pagetag
32	picata	postgrouppage
33	picata	splitviewpage
34	picata	article
35	picata	pagetagrelation
36	picata	socialsettings
37	wagtailforms	formsubmission
38	wagtailredirects	redirect
39	wagtailembeds	embed
40	wagtailusers	userprofile
41	wagtailimages	rendition
42	wagtailsearch	indexentry
43	wagtailadmin	editingsession
44	taggit	tag
45	taggit	taggeditem
46	admin	logentry
47	auth	permission
48	auth	group
49	auth	user
50	contenttypes	contenttype
51	sessions	session
52	picata	postseries
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: wagtail
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add image	2	add_image
2	Can change image	2	change_image
3	Can delete image	2	delete_image
4	Can choose image	2	choose_image
5	Can add locale	4	add_locale
6	Can change locale	4	change_locale
7	Can delete locale	4	delete_locale
8	Can view locale	4	view_locale
9	Can add site	5	add_site
10	Can change site	5	change_site
11	Can delete site	5	delete_site
12	Can view site	5	view_site
13	Can add model log entry	6	add_modellogentry
14	Can change model log entry	6	change_modellogentry
15	Can delete model log entry	6	delete_modellogentry
16	Can view model log entry	6	view_modellogentry
17	Can add collection view restriction	7	add_collectionviewrestriction
18	Can change collection view restriction	7	change_collectionviewrestriction
19	Can delete collection view restriction	7	delete_collectionviewrestriction
20	Can view collection view restriction	7	view_collectionviewrestriction
21	Can add collection	8	add_collection
22	Can change collection	8	change_collection
23	Can delete collection	8	delete_collection
24	Can view collection	8	view_collection
25	Can add group collection permission	9	add_groupcollectionpermission
26	Can change group collection permission	9	change_groupcollectionpermission
27	Can delete group collection permission	9	delete_groupcollectionpermission
28	Can view group collection permission	9	view_groupcollectionpermission
29	Can add uploaded file	10	add_uploadedfile
30	Can change uploaded file	10	change_uploadedfile
31	Can delete uploaded file	10	delete_uploadedfile
32	Can view uploaded file	10	view_uploadedfile
33	Can add reference index	11	add_referenceindex
34	Can change reference index	11	change_referenceindex
35	Can delete reference index	11	delete_referenceindex
36	Can view reference index	11	view_referenceindex
37	Can add page	1	add_page
38	Can change page	1	change_page
39	Can delete page	1	delete_page
40	Can view page	1	view_page
41	Delete pages with children	1	bulk_delete_page
42	Lock/unlock pages you've locked	1	lock_page
43	Publish any page	1	publish_page
44	Unlock any page	1	unlock_page
45	Can add revision	12	add_revision
46	Can change revision	12	change_revision
47	Can delete revision	12	delete_revision
48	Can view revision	12	view_revision
49	Can add group page permission	13	add_grouppagepermission
50	Can change group page permission	13	change_grouppagepermission
51	Can delete group page permission	13	delete_grouppagepermission
52	Can view group page permission	13	view_grouppagepermission
53	Can add page view restriction	14	add_pageviewrestriction
54	Can change page view restriction	14	change_pageviewrestriction
55	Can delete page view restriction	14	delete_pageviewrestriction
56	Can view page view restriction	14	view_pageviewrestriction
57	Can add workflow page	15	add_workflowpage
58	Can change workflow page	15	change_workflowpage
59	Can delete workflow page	15	delete_workflowpage
60	Can view workflow page	15	view_workflowpage
61	Can add workflow content type	16	add_workflowcontenttype
62	Can change workflow content type	16	change_workflowcontenttype
63	Can delete workflow content type	16	delete_workflowcontenttype
64	Can view workflow content type	16	view_workflowcontenttype
65	Can add workflow task order	17	add_workflowtask
66	Can change workflow task order	17	change_workflowtask
67	Can delete workflow task order	17	delete_workflowtask
68	Can view workflow task order	17	view_workflowtask
69	Can add task	18	add_task
70	Can change task	18	change_task
71	Can delete task	18	delete_task
72	Can view task	18	view_task
73	Can add workflow	19	add_workflow
74	Can change workflow	19	change_workflow
75	Can delete workflow	19	delete_workflow
76	Can view workflow	19	view_workflow
77	Can add Group approval task	3	add_groupapprovaltask
78	Can change Group approval task	3	change_groupapprovaltask
79	Can delete Group approval task	3	delete_groupapprovaltask
80	Can view Group approval task	3	view_groupapprovaltask
81	Can add Workflow state	20	add_workflowstate
82	Can change Workflow state	20	change_workflowstate
83	Can delete Workflow state	20	delete_workflowstate
84	Can view Workflow state	20	view_workflowstate
85	Can add Task state	21	add_taskstate
86	Can change Task state	21	change_taskstate
87	Can delete Task state	21	delete_taskstate
88	Can view Task state	21	view_taskstate
89	Can add page log entry	22	add_pagelogentry
90	Can change page log entry	22	change_pagelogentry
91	Can delete page log entry	22	delete_pagelogentry
92	Can view page log entry	22	view_pagelogentry
93	Can add comment	23	add_comment
94	Can change comment	23	change_comment
95	Can delete comment	23	delete_comment
96	Can view comment	23	view_comment
97	Can add comment reply	24	add_commentreply
98	Can change comment reply	24	change_commentreply
99	Can delete comment reply	24	delete_commentreply
100	Can view comment reply	24	view_commentreply
101	Can add page subscription	25	add_pagesubscription
102	Can change page subscription	25	change_pagesubscription
103	Can delete page subscription	25	delete_pagesubscription
104	Can view page subscription	25	view_pagesubscription
105	Can access Wagtail admin	26	access_admin
106	Can add document	27	add_document
107	Can change document	27	change_document
108	Can delete document	27	delete_document
109	Can choose document	27	choose_document
110	Can add article type	28	add_articletype
111	Can change article type	28	change_articletype
112	Can delete article type	28	delete_articletype
113	Can view article type	28	view_articletype
114	Can add basic page	29	add_basicpage
115	Can change basic page	29	change_basicpage
116	Can delete basic page	29	delete_basicpage
117	Can view basic page	29	view_basicpage
118	Can add home page	30	add_homepage
119	Can change home page	30	change_homepage
120	Can delete home page	30	delete_homepage
121	Can view home page	30	view_homepage
122	Can add page tag	31	add_pagetag
123	Can change page tag	31	change_pagetag
124	Can delete page tag	31	delete_pagetag
125	Can view page tag	31	view_pagetag
126	Can add post listing	32	add_postgrouppage
127	Can change post listing	32	change_postgrouppage
128	Can delete post listing	32	delete_postgrouppage
129	Can view post listing	32	view_postgrouppage
130	Can add split-view page	33	add_splitviewpage
131	Can change split-view page	33	change_splitviewpage
132	Can delete split-view page	33	delete_splitviewpage
133	Can view split-view page	33	view_splitviewpage
134	Can add article	34	add_article
135	Can change article	34	change_article
136	Can delete article	34	delete_article
137	Can view article	34	view_article
138	Can add page tag relation	35	add_pagetagrelation
139	Can change page tag relation	35	change_pagetagrelation
140	Can delete page tag relation	35	delete_pagetagrelation
141	Can view page tag relation	35	view_pagetagrelation
142	Can add social settings	36	add_socialsettings
143	Can change social settings	36	change_socialsettings
144	Can delete social settings	36	delete_socialsettings
145	Can view social settings	36	view_socialsettings
146	Can add form submission	37	add_formsubmission
147	Can change form submission	37	change_formsubmission
148	Can delete form submission	37	delete_formsubmission
149	Can view form submission	37	view_formsubmission
150	Can add redirect	38	add_redirect
151	Can change redirect	38	change_redirect
152	Can delete redirect	38	delete_redirect
153	Can view redirect	38	view_redirect
154	Can add embed	39	add_embed
155	Can change embed	39	change_embed
156	Can delete embed	39	delete_embed
157	Can view embed	39	view_embed
158	Can add user profile	40	add_userprofile
159	Can change user profile	40	change_userprofile
160	Can delete user profile	40	delete_userprofile
161	Can view user profile	40	view_userprofile
162	Can view document	27	view_document
163	Can view image	2	view_image
164	Can add rendition	41	add_rendition
165	Can change rendition	41	change_rendition
166	Can delete rendition	41	delete_rendition
167	Can view rendition	41	view_rendition
168	Can add index entry	42	add_indexentry
169	Can change index entry	42	change_indexentry
170	Can delete index entry	42	delete_indexentry
171	Can view index entry	42	view_indexentry
172	Can add editing session	43	add_editingsession
173	Can change editing session	43	change_editingsession
174	Can delete editing session	43	delete_editingsession
175	Can view editing session	43	view_editingsession
176	Can add tag	44	add_tag
177	Can change tag	44	change_tag
178	Can delete tag	44	delete_tag
179	Can view tag	44	view_tag
180	Can add tagged item	45	add_taggeditem
181	Can change tagged item	45	change_taggeditem
182	Can delete tagged item	45	delete_taggeditem
183	Can view tagged item	45	view_taggeditem
184	Can add log entry	46	add_logentry
185	Can change log entry	46	change_logentry
186	Can delete log entry	46	delete_logentry
187	Can view log entry	46	view_logentry
188	Can add permission	47	add_permission
189	Can change permission	47	change_permission
190	Can delete permission	47	delete_permission
191	Can view permission	47	view_permission
192	Can add group	48	add_group
193	Can change group	48	change_group
194	Can delete group	48	delete_group
195	Can view group	48	view_group
196	Can add user	49	add_user
197	Can change user	49	change_user
198	Can delete user	49	delete_user
199	Can view user	49	view_user
200	Can add content type	50	add_contenttype
201	Can change content type	50	change_contenttype
202	Can delete content type	50	delete_contenttype
203	Can view content type	50	view_contenttype
204	Can add session	51	add_session
205	Can change session	51	change_session
206	Can delete session	51	delete_session
207	Can view session	51	view_session
208	Can add post series	52	add_postseries
209	Can change post series	52	change_postseries
210	Can delete post series	52	delete_postseries
211	Can view post series	52	view_postseries
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: wagtail
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	2	1
5	2	2
6	2	3
7	1	105
8	2	105
9	1	106
10	1	107
11	1	108
12	2	106
13	2	107
14	2	108
15	1	109
16	2	109
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: wagtail
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2025-01-24 00:34:07.18202+00
2	auth	0001_initial	2025-01-24 00:34:07.257784+00
3	admin	0001_initial	2025-01-24 00:34:07.281981+00
4	admin	0002_logentry_remove_auto_add	2025-01-24 00:34:07.294454+00
5	admin	0003_logentry_add_action_flag_choices	2025-01-24 00:34:07.304214+00
6	contenttypes	0002_remove_content_type_name	2025-01-24 00:34:07.334763+00
7	auth	0002_alter_permission_name_max_length	2025-01-24 00:34:07.347129+00
8	auth	0003_alter_user_email_max_length	2025-01-24 00:34:07.466174+00
9	auth	0004_alter_user_username_opts	2025-01-24 00:34:07.477669+00
10	auth	0005_alter_user_last_login_null	2025-01-24 00:34:07.489549+00
11	auth	0006_require_contenttypes_0002	2025-01-24 00:34:07.493661+00
12	auth	0007_alter_validators_add_error_messages	2025-01-24 00:34:07.50446+00
13	auth	0008_alter_user_username_max_length	2025-01-24 00:34:07.520408+00
14	auth	0009_alter_user_last_name_max_length	2025-01-24 00:34:07.534093+00
15	auth	0010_alter_group_name_max_length	2025-01-24 00:34:07.548673+00
16	auth	0011_update_proxy_permissions	2025-01-24 00:34:07.563774+00
17	auth	0012_alter_user_first_name_max_length	2025-01-24 00:34:07.577652+00
18	wagtailcore	0001_initial	2025-01-24 00:34:07.904604+00
19	wagtailcore	0002_initial_data	2025-01-24 00:34:07.906384+00
20	wagtailcore	0003_add_uniqueness_constraint_on_group_page_permission	2025-01-24 00:34:07.909142+00
21	wagtailcore	0004_page_locked	2025-01-24 00:34:07.910624+00
22	wagtailcore	0005_add_page_lock_permission_to_moderators	2025-01-24 00:34:07.911806+00
23	wagtailcore	0006_add_lock_page_permission	2025-01-24 00:34:07.912925+00
24	wagtailcore	0007_page_latest_revision_created_at	2025-01-24 00:34:07.914028+00
25	wagtailcore	0008_populate_latest_revision_created_at	2025-01-24 00:34:07.914965+00
26	wagtailcore	0009_remove_auto_now_add_from_pagerevision_created_at	2025-01-24 00:34:07.915913+00
27	wagtailcore	0010_change_page_owner_to_null_on_delete	2025-01-24 00:34:07.916949+00
28	wagtailcore	0011_page_first_published_at	2025-01-24 00:34:07.918144+00
29	wagtailcore	0012_extend_page_slug_field	2025-01-24 00:34:07.919339+00
30	wagtailcore	0013_update_golive_expire_help_text	2025-01-24 00:34:07.920394+00
31	wagtailcore	0014_add_verbose_name	2025-01-24 00:34:07.921585+00
32	wagtailcore	0015_add_more_verbose_names	2025-01-24 00:34:07.922632+00
33	wagtailcore	0016_change_page_url_path_to_text_field	2025-01-24 00:34:07.923505+00
34	wagtailcore	0017_change_edit_page_permission_description	2025-01-24 00:34:07.938375+00
35	wagtailcore	0018_pagerevision_submitted_for_moderation_index	2025-01-24 00:34:07.976008+00
36	wagtailcore	0019_verbose_names_cleanup	2025-01-24 00:34:08.023485+00
37	wagtailcore	0020_add_index_on_page_first_published_at	2025-01-24 00:34:08.041209+00
38	wagtailcore	0021_capitalizeverbose	2025-01-24 00:34:08.429835+00
39	wagtailcore	0022_add_site_name	2025-01-24 00:34:08.448606+00
40	wagtailcore	0023_alter_page_revision_on_delete_behaviour	2025-01-24 00:34:08.468599+00
41	wagtailcore	0024_collection	2025-01-24 00:34:08.481052+00
42	wagtailcore	0025_collection_initial_data	2025-01-24 00:34:08.497829+00
43	wagtailcore	0026_group_collection_permission	2025-01-24 00:34:08.540733+00
44	taggit	0001_initial	2025-01-24 00:34:08.583703+00
45	wagtailimages	0001_initial	2025-01-24 00:34:08.758853+00
46	wagtailimages	0002_initial_data	2025-01-24 00:34:08.760879+00
47	wagtailimages	0003_fix_focal_point_fields	2025-01-24 00:34:08.762449+00
48	wagtailimages	0004_make_focal_point_key_not_nullable	2025-01-24 00:34:08.763936+00
49	wagtailimages	0005_make_filter_spec_unique	2025-01-24 00:34:08.765293+00
50	wagtailimages	0006_add_verbose_names	2025-01-24 00:34:08.768005+00
51	wagtailimages	0007_image_file_size	2025-01-24 00:34:08.769392+00
52	wagtailimages	0008_image_created_at_index	2025-01-24 00:34:08.770605+00
53	wagtailimages	0009_capitalizeverbose	2025-01-24 00:34:08.771697+00
54	wagtailimages	0010_change_on_delete_behaviour	2025-01-24 00:34:08.772851+00
55	wagtailimages	0011_image_collection	2025-01-24 00:34:08.77387+00
56	wagtailimages	0012_copy_image_permissions_to_collections	2025-01-24 00:34:08.774854+00
57	wagtailimages	0013_make_rendition_upload_callable	2025-01-24 00:34:08.775893+00
58	wagtailimages	0014_add_filter_spec_field	2025-01-24 00:34:08.776997+00
59	wagtailimages	0015_fill_filter_spec_field	2025-01-24 00:34:08.778037+00
60	wagtailimages	0016_deprecate_rendition_filter_relation	2025-01-24 00:34:08.77908+00
61	wagtailimages	0017_reduce_focal_point_key_max_length	2025-01-24 00:34:08.780007+00
62	wagtailimages	0018_remove_rendition_filter	2025-01-24 00:34:08.781055+00
63	wagtailimages	0019_delete_filter	2025-01-24 00:34:08.782062+00
64	wagtailimages	0020_add-verbose-name	2025-01-24 00:34:08.783166+00
65	wagtailimages	0021_image_file_hash	2025-01-24 00:34:08.784137+00
66	wagtailimages	0022_uploadedimage	2025-01-24 00:34:08.81864+00
67	wagtailimages	0023_add_choose_permissions	2025-01-24 00:34:08.903857+00
68	wagtailimages	0024_index_image_file_hash	2025-01-24 00:34:08.951979+00
69	wagtailimages	0025_alter_image_file_alter_rendition_file	2025-01-24 00:34:08.980234+00
70	wagtailimages	0026_delete_uploadedimage	2025-01-24 00:34:08.985829+00
71	wagtailimages	0027_image_description	2025-01-24 00:34:09.009509+00
72	wagtailcore	0027_fix_collection_path_collation	2025-01-24 00:34:09.039173+00
73	wagtailcore	0024_alter_page_content_type_on_delete_behaviour	2025-01-24 00:34:09.06976+00
74	wagtailcore	0028_merge	2025-01-24 00:34:09.072597+00
75	wagtailcore	0029_unicode_slugfield_dj19	2025-01-24 00:34:09.103727+00
76	wagtailcore	0030_index_on_pagerevision_created_at	2025-01-24 00:34:09.123852+00
77	wagtailcore	0031_add_page_view_restriction_types	2025-01-24 00:34:09.211283+00
78	wagtailcore	0032_add_bulk_delete_page_permission	2025-01-24 00:34:09.226665+00
79	wagtailcore	0033_remove_golive_expiry_help_text	2025-01-24 00:34:09.264525+00
80	wagtailcore	0034_page_live_revision	2025-01-24 00:34:09.296456+00
81	wagtailcore	0035_page_last_published_at	2025-01-24 00:34:09.318867+00
82	wagtailcore	0036_populate_page_last_published_at	2025-01-24 00:34:09.35256+00
83	wagtailcore	0037_set_page_owner_editable	2025-01-24 00:34:09.382116+00
84	wagtailcore	0038_make_first_published_at_editable	2025-01-24 00:34:09.423136+00
85	wagtailcore	0039_collectionviewrestriction	2025-01-24 00:34:09.504481+00
86	wagtailcore	0040_page_draft_title	2025-01-24 00:34:09.552879+00
87	wagtailcore	0041_group_collection_permissions_verbose_name_plural	2025-01-24 00:34:09.573449+00
88	wagtailcore	0042_index_on_pagerevision_approved_go_live_at	2025-01-24 00:34:09.597527+00
89	wagtailcore	0043_lock_fields	2025-01-24 00:34:09.64779+00
90	wagtailcore	0044_add_unlock_grouppagepermission	2025-01-24 00:34:09.681043+00
91	wagtailcore	0045_assign_unlock_grouppagepermission	2025-01-24 00:34:09.718734+00
92	wagtailcore	0046_site_name_remove_null	2025-01-24 00:34:09.763049+00
93	wagtailcore	0047_add_workflow_models	2025-01-24 00:34:10.259404+00
94	wagtailcore	0048_add_default_workflows	2025-01-24 00:34:10.360178+00
95	wagtailcore	0049_taskstate_finished_by	2025-01-24 00:34:10.409438+00
96	wagtailcore	0050_workflow_rejected_to_needs_changes	2025-01-24 00:34:10.508032+00
97	wagtailcore	0051_taskstate_comment	2025-01-24 00:34:10.542546+00
98	wagtailcore	0052_pagelogentry	2025-01-24 00:34:10.629009+00
99	wagtailcore	0053_locale_model	2025-01-24 00:34:10.646834+00
100	wagtailcore	0054_initial_locale	2025-01-24 00:34:10.700795+00
101	wagtailcore	0055_page_locale_fields	2025-01-24 00:34:10.830518+00
102	wagtailcore	0056_page_locale_fields_populate	2025-01-24 00:34:10.883431+00
103	wagtailcore	0057_page_locale_fields_notnull	2025-01-24 00:34:10.981547+00
104	wagtailcore	0058_page_alias_of	2025-01-24 00:34:11.024465+00
105	wagtailcore	0059_apply_collection_ordering	2025-01-24 00:34:11.073888+00
106	wagtailcore	0060_fix_workflow_unique_constraint	2025-01-24 00:34:11.128082+00
107	wagtailcore	0061_change_promote_tab_helpt_text_and_verbose_names	2025-01-24 00:34:11.185814+00
108	wagtailcore	0062_comment_models_and_pagesubscription	2025-01-24 00:34:11.559492+00
109	wagtailcore	0063_modellogentry	2025-01-24 00:34:11.621862+00
110	wagtailcore	0064_log_timestamp_indexes	2025-01-24 00:34:11.679379+00
111	wagtailcore	0065_log_entry_uuid	2025-01-24 00:34:11.751076+00
112	wagtailcore	0066_collection_management_permissions	2025-01-24 00:34:11.803521+00
113	wagtailcore	0067_alter_pagerevision_content_json	2025-01-24 00:34:11.881645+00
114	wagtailcore	0068_log_entry_empty_object	2025-01-24 00:34:11.925265+00
115	wagtailcore	0069_log_entry_jsonfield	2025-01-24 00:34:12.076049+00
116	wagtailcore	0070_rename_pagerevision_revision	2025-01-24 00:34:12.465039+00
117	wagtailcore	0071_populate_revision_content_type	2025-01-24 00:34:12.510141+00
118	wagtailcore	0072_alter_revision_content_type_notnull	2025-01-24 00:34:12.599262+00
119	wagtailcore	0073_page_latest_revision	2025-01-24 00:34:12.642531+00
120	wagtailcore	0074_revision_object_str	2025-01-24 00:34:12.670861+00
121	wagtailcore	0075_populate_latest_revision_and_revision_object_str	2025-01-24 00:34:12.760903+00
122	wagtailcore	0076_modellogentry_revision	2025-01-24 00:34:12.81169+00
123	wagtailcore	0077_alter_revision_user	2025-01-24 00:34:12.866586+00
124	wagtailcore	0078_referenceindex	2025-01-24 00:34:12.944894+00
125	wagtailcore	0079_rename_taskstate_page_revision	2025-01-24 00:34:12.992541+00
126	wagtailcore	0080_generic_workflowstate	2025-01-24 00:34:13.366761+00
127	wagtailcore	0081_populate_workflowstate_content_type	2025-01-24 00:34:13.412178+00
128	wagtailcore	0082_alter_workflowstate_content_type_notnull	2025-01-24 00:34:13.520419+00
129	wagtailcore	0083_workflowcontenttype	2025-01-24 00:34:13.584432+00
130	wagtailcore	0084_add_default_page_permissions	2025-01-24 00:34:13.624999+00
131	wagtailcore	0085_add_grouppagepermission_permission	2025-01-24 00:34:13.694187+00
132	wagtailcore	0086_populate_grouppagepermission_permission	2025-01-24 00:34:13.794172+00
133	wagtailcore	0087_alter_grouppagepermission_unique_together_and_more	2025-01-24 00:34:13.911963+00
134	wagtailcore	0088_fix_log_entry_json_timestamps	2025-01-24 00:34:14.030403+00
135	wagtailcore	0089_log_entry_data_json_null_to_object	2025-01-24 00:34:14.08528+00
136	wagtailcore	0090_remove_grouppagepermission_permission_type	2025-01-24 00:34:14.233487+00
137	wagtailcore	0091_remove_revision_submitted_for_moderation	2025-01-24 00:34:14.270487+00
138	wagtailcore	0092_alter_collectionviewrestriction_password_and_more	2025-01-24 00:34:14.59969+00
139	wagtailcore	0093_uploadedfile	2025-01-24 00:34:14.653987+00
140	wagtailcore	0094_alter_page_locale	2025-01-24 00:34:14.70721+00
141	picata	0001_initial	2025-01-24 00:34:15.278464+00
142	sessions	0001_initial	2025-01-24 00:34:15.300371+00
143	taggit	0002_auto_20150616_2121	2025-01-24 00:34:15.334844+00
144	taggit	0003_taggeditem_add_unique_index	2025-01-24 00:34:15.367277+00
145	taggit	0004_alter_taggeditem_content_type_alter_taggeditem_tag	2025-01-24 00:34:15.489875+00
146	taggit	0005_auto_20220424_2025	2025-01-24 00:34:15.533996+00
147	taggit	0006_rename_taggeditem_content_type_object_id_taggit_tagg_content_8fc721_idx	2025-01-24 00:34:15.578664+00
148	wagtailadmin	0001_create_admin_access_permissions	2025-01-24 00:34:15.634323+00
149	wagtailadmin	0002_admin	2025-01-24 00:34:15.63802+00
150	wagtailadmin	0003_admin_managed	2025-01-24 00:34:15.647162+00
151	wagtailadmin	0004_editingsession	2025-01-24 00:34:15.729029+00
152	wagtailadmin	0005_editingsession_is_editing	2025-01-24 00:34:15.762486+00
153	wagtaildocs	0001_initial	2025-01-24 00:34:15.833607+00
154	wagtaildocs	0002_initial_data	2025-01-24 00:34:15.91324+00
155	wagtaildocs	0003_add_verbose_names	2025-01-24 00:34:16.036422+00
156	wagtaildocs	0004_capitalizeverbose	2025-01-24 00:34:16.259566+00
157	wagtaildocs	0005_document_collection	2025-01-24 00:34:16.322426+00
158	wagtaildocs	0006_copy_document_permissions_to_collections	2025-01-24 00:34:16.378864+00
159	wagtaildocs	0005_alter_uploaded_by_user_on_delete_action	2025-01-24 00:34:16.436256+00
160	wagtaildocs	0007_merge	2025-01-24 00:34:16.439143+00
161	wagtaildocs	0008_document_file_size	2025-01-24 00:34:16.473807+00
162	wagtaildocs	0009_document_verbose_name_plural	2025-01-24 00:34:16.514362+00
163	wagtaildocs	0010_document_file_hash	2025-01-24 00:34:16.558739+00
164	wagtaildocs	0011_add_choose_permissions	2025-01-24 00:34:16.756935+00
165	wagtaildocs	0012_uploadeddocument	2025-01-24 00:34:16.834797+00
166	wagtaildocs	0013_delete_uploadeddocument	2025-01-24 00:34:16.840182+00
167	wagtaildocs	0014_alter_document_file_size	2025-01-24 00:34:16.886986+00
168	wagtailembeds	0001_initial	2025-01-24 00:34:16.905621+00
169	wagtailembeds	0002_add_verbose_names	2025-01-24 00:34:16.911338+00
170	wagtailembeds	0003_capitalizeverbose	2025-01-24 00:34:16.916814+00
171	wagtailembeds	0004_embed_verbose_name_plural	2025-01-24 00:34:16.923039+00
172	wagtailembeds	0005_specify_thumbnail_url_max_length	2025-01-24 00:34:16.931112+00
173	wagtailembeds	0006_add_embed_hash	2025-01-24 00:34:16.94081+00
174	wagtailembeds	0007_populate_hash	2025-01-24 00:34:17.014358+00
175	wagtailembeds	0008_allow_long_urls	2025-01-24 00:34:17.055802+00
176	wagtailembeds	0009_embed_cache_until	2025-01-24 00:34:17.065483+00
177	wagtailforms	0001_initial	2025-01-24 00:34:17.12854+00
178	wagtailforms	0002_add_verbose_names	2025-01-24 00:34:17.176983+00
179	wagtailforms	0003_capitalizeverbose	2025-01-24 00:34:17.228458+00
180	wagtailforms	0004_add_verbose_name_plural	2025-01-24 00:34:17.257753+00
181	wagtailforms	0005_alter_formsubmission_form_data	2025-01-24 00:34:17.315555+00
182	wagtailredirects	0001_initial	2025-01-24 00:34:17.39174+00
183	wagtailredirects	0002_add_verbose_names	2025-01-24 00:34:17.475147+00
184	wagtailredirects	0003_make_site_field_editable	2025-01-24 00:34:17.524393+00
185	wagtailredirects	0004_set_unique_on_path_and_site	2025-01-24 00:34:17.858458+00
186	wagtailredirects	0005_capitalizeverbose	2025-01-24 00:34:18.079078+00
187	wagtailredirects	0006_redirect_increase_max_length	2025-01-24 00:34:18.109822+00
188	wagtailredirects	0007_add_autocreate_fields	2025-01-24 00:34:18.190438+00
189	wagtailredirects	0008_add_verbose_name_plural	2025-01-24 00:34:18.215888+00
190	wagtailsearch	0001_initial	2025-01-24 00:34:18.389659+00
191	wagtailsearch	0002_add_verbose_names	2025-01-24 00:34:18.512595+00
192	wagtailsearch	0003_remove_editors_pick	2025-01-24 00:34:18.515232+00
193	wagtailsearch	0004_querydailyhits_verbose_name_plural	2025-01-24 00:34:18.522751+00
194	wagtailsearch	0005_create_indexentry	2025-01-24 00:34:18.661262+00
195	wagtailsearch	0006_customise_indexentry	2025-01-24 00:34:18.813402+00
196	wagtailsearch	0007_delete_editorspick	2025-01-24 00:34:18.827501+00
197	wagtailsearch	0008_remove_query_and_querydailyhits_models	2025-01-24 00:34:18.861616+00
198	wagtailusers	0001_initial	2025-01-24 00:34:18.946666+00
199	wagtailusers	0002_add_verbose_name_on_userprofile	2025-01-24 00:34:19.039702+00
200	wagtailusers	0003_add_verbose_names	2025-01-24 00:34:19.070448+00
201	wagtailusers	0004_capitalizeverbose	2025-01-24 00:34:19.194548+00
202	wagtailusers	0005_make_related_name_wagtail_specific	2025-01-24 00:34:19.264583+00
203	wagtailusers	0006_userprofile_prefered_language	2025-01-24 00:34:19.305009+00
204	wagtailusers	0007_userprofile_current_time_zone	2025-01-24 00:34:19.342871+00
205	wagtailusers	0008_userprofile_avatar	2025-01-24 00:34:19.378519+00
206	wagtailusers	0009_userprofile_verbose_name_plural	2025-01-24 00:34:19.428399+00
207	wagtailusers	0010_userprofile_updated_comments_notifications	2025-01-24 00:34:19.466168+00
208	wagtailusers	0011_userprofile_dismissibles	2025-01-24 00:34:19.510253+00
209	wagtailusers	0012_userprofile_theme	2025-01-24 00:34:19.55292+00
210	wagtailusers	0013_userprofile_density	2025-01-24 00:34:19.590984+00
211	wagtailusers	0014_userprofile_contrast	2025-01-24 00:34:19.628532+00
212	wagtailimages	0001_squashed_0021	2025-01-24 00:34:19.641243+00
213	wagtailcore	0001_squashed_0016_change_page_url_path_to_text_field	2025-01-24 00:34:19.644137+00
214	picata	0002_postseries	2025-02-05 01:17:09.472972+00
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wagtail
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 2, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wagtail
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 16, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wagtail
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 211, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wagtail
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 52, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wagtail
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 214, true);


--
-- PostgreSQL database dump complete
--
