{**
 * Страница пользователя
 *
 * @styles user.css
 *}

{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}


{* Actionbar *}
{block name='layout_content_actionbar_class'}actionbar-user{/block}
{block name='layout_content_actionbar'}
	<ul>
		<li><a href="#"><i class="icon-white icon-pencil"></i></a></li>

		{include file="{$aTemplatePathPlugin.admin}actions/ActionAdmin/users/user_operations.tpl"}

		<li class="fl-r"><a href="#"><i class="icon-white icon-chevron-right"></i></a></li>
		<li class="fl-r"><a href="#"><i class="icon-white icon-chevron-left"></i></a></li>
	</ul>
{/block}


{*
	Меню
*}
{block name='layout_content_before'}
	<header class="user-header">
		<div class="user-brief clearfix">
			<div class="user-brief-body">
				<a href="{$oUser->getUserWebPath()}" class="user-avatar {if $oUser->isOnline()}user-is-online{/if}">
					<img src="{$oUser->getProfileAvatarPath(100)}" 
						 alt="avatar" 
						 title="{if $oUser->isOnline()}{$aLang.user_status_online}{else}{$aLang.user_status_offline}{/if}" />
				</a>

				<h3 class="user-login">
					{*
						инлайн редактирование поля
					*}
					<span class="profile-inline-edit-input" data-item-type="login" data-item-id="{$oUser->getId()}">{$oUser->getLogin()}</span>

					{if $oUser->isAdministrator()}
						<i class="icon-user-admin" title="{$aLang.plugin.admin.users.admin}"></i>
					{/if}
				</h3>

				{if $oUser->getProfileName()}
					{*
						инлайн редактирование поля
					*}
					<p class="user-name profile-inline-edit-input" data-item-type="profile_name" data-item-id="{$oUser->getId()}">{$oUser->getProfileName()}</p>
				{/if}

				<p class="user-mail">
					{*
						инлайн редактирование поля
					*}
					<span class="profile-inline-edit-input" data-item-type="mail" data-item-id="{$oUser->getId()}">{$oUser->getMail()}</span>
					<a href="mailto:{$oUser->getMail()}" class="link-border"><i class="icon-envelope"></i></a>
				</p>

				<p class="user-id">{$aLang.plugin.admin.users.profile.user_no}{$oUser->getId()}</p>
			</div>

			{*
				Редактирование рейтинга
			*}
			<div class="user-brief-aside">
				<div class="edit-rating">
					<i class="icon-rating" title="{$aLang.plugin.admin.users.profile_edit.rating}"></i>
					{*
						инлайн редактирование поля
					*}
					<span class="link-dotted profile-inline-edit-input" data-item-type="rating" data-item-id="{$oUser->getId()}">{$oUser->getRating()}</span>
				</div>

				<div class="edit-skill">
					{$aLang.plugin.admin.users.profile_edit.skill}
					{*
						инлайн редактирование поля
					*}
					<span class="link-dotted profile-inline-edit-input" data-item-type="skill" data-item-id="{$oUser->getId()}">{$oUser->getSkill()}</span>
				</div>

				<div class="edit-password">
					{$aLang.plugin.admin.users.profile_edit.password}
					{*
						инлайн редактирование поля
					*}
					<span class="link-dotted profile-inline-edit-input" data-item-type="password" data-item-id="{$oUser->getId()}">*******</span>
				</div>

				<div class="edit-about-user">
					{$aLang.plugin.admin.users.profile_edit.about_user}
					{*
						инлайн редактирование поля
					*}
					<span class="link-dotted profile-inline-edit-input" data-item-type="about" data-item-id="{$oUser->getId()}">{$oUser->getProfileAbout()}</span>
				</div>

				<div class="get-user-baneed">
					{*
						для вывода информации бана
					*}
					{hook run='admin_user_profile_brief_aside' oUserProfile=$oUser}        {* todo: review: hook names *}
				</div>
			</div>
		</div>
	</header>
{/block}


{block name='layout_content'}
	{$oSession = $oUser->getSession()}

	<aside class="user-info-aside">
		<div class="block block-user-photo">
			<a href="{$oUser->getUserWebPath()}"><img src="{$oUser->getProfileFotoPath()}" alt="" class="photo" /></a>
		</div>

		{include file="blocks/block.userNote.tpl" oUserProfile=$oUser oUserNote=$oUser->getUserNote()}

		<div class="block block-user-menu">
			<ul class="user-menu">
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.profile}</span></a></li>
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}created/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.publications}</span></a></li>
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}stream/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.activity}</span></a></li>
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}friends/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.friends}</span></a></li>
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Жалобы</span></a></li>*}
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Счет</span></a></li>*}
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}wall/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.wall}</span></a></li>
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Блоги</span></a></li>*}
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}favourites/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.fav}</span></a></li>
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Почта</span></a></li>*}
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Права</span></a></li>*}
			</ul>
		</div>
	</aside>


	<div class="user-info-body">
		{*
			Базовая информация
		*}
		<div class="user-info-block user-info-block-resume">
			<h2 class="user-info-heading">{$aLang.plugin.admin.users.profile.info.resume}</h2>

			<dl class="dotted-list-item">
				<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.mail}</dt>
				<dd class="dotted-list-item-value">
					<a href="{router page='admin/users/list'}{request_filter
						name=array('mail')
						value=array($oUser->getMail())
					}">{$oUser->getMail()}</a>
				</dd>
			</dl>
			{if $oUser->getProfileSex() != 'other'}
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.sex}</dt>
					<dd class="dotted-list-item-value">
						{if $oUser->getProfileSex() == 'man'}
							{$aLang.profile_sex_man}
						{else}
							{$aLang.profile_sex_woman}
						{/if}
					</dd>
				</dl>
			{/if}
			{if $oUser->getProfileBirthday()}
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.birthday}</dt>
					<dd class="dotted-list-item-value">{date_format date=$oUser->getProfileBirthday() format="j F Y" notz=true}</dd>
				</dl>
			{/if}

			{if $oGeoTarget}
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.living}</dt>
					<dd class="dotted-list-item-value">
						{if $oGeoTarget->getCountryId()}
							<a href="{router page='people/country'}{$oGeoTarget->getCountryId()}/">{$oUser->getProfileCountry()|escape:'html'}</a>{if $oGeoTarget->getCityId()},{/if}
						{/if}

						{if $oGeoTarget->getCityId()}
							<a href="{router page='people/city'}{$oGeoTarget->getCityId()}/">{$oUser->getProfileCity()|escape:'html'}</a>
						{/if}
					</dd>
				</dl>
			{/if}

			<dl class="dotted-list-item mt-20">
				<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.reg_date}</dt>
				<dd class="dotted-list-item-value">{date_format date=$oUser->getDateRegister()}</dd>
			</dl>
			<dl class="dotted-list-item">
				<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.ip}</dt>
				<dd class="dotted-list-item-value">
					<a href="{router page='admin/users/list'}{request_filter
						name=array('ip_register')
						value=array($oUser->getIpRegister())
					}">{$oUser->getIpRegister()}</a>
				</dd>
			</dl>

			{if $oSession}
				<dl class="dotted-list-item mt-20">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.last_visit}</dt>
					<dd class="dotted-list-item-value">{date_format date=$oSession->getDateLast()}</dd>
				</dl>
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.ip}</dt>
					<dd class="dotted-list-item-value">
						<a href="{router page='admin/users/list'}{request_filter
							name=array('session_ip_last')
							value=array($oSession->getIpLast())
						}">{$oSession->getIpLast()}</a>
						<br />
						<a href="{router page='admin/users/list'}{request_filter
							name=array('session_ip_last')
							value=array($oSession->getIpLast())
						}" class="button mt-10">{$aLang.plugin.admin.users.profile.info.search_this_ip}</a>
					</dd>
				</dl>
			{/if}
		</div>

		{*
			Статистика
		*}
		<div class="user-info-block user-info-block-stats">
			<h2 class="user-info-heading">{$aLang.plugin.admin.users.profile.info.stats_title}</h2>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.created}</div>
				<ul>
					{* todo: fill hrefs in links or leave just a text? *}
					<li><a href="#" class="link-border"><span>{$iCountTopicUser} {$aLang.plugin.admin.users.profile.info.topics}</span></a></li>
					<li><a href="#" class="link-border"><span>{$iCountCommentUser} {$aLang.plugin.admin.users.profile.info.comments}</span></a></li>
					<li><a href="#" class="link-border"><span>{$iCountBlogsUser} {$aLang.plugin.admin.users.profile.info.blogs}</span></a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.fav}</div>
				<ul>
					<li><a href="#" class="link-border"><span>{$iCountTopicFavourite} {$aLang.plugin.admin.users.profile.info.topics}</span></a></li>
					<li><a href="#" class="link-border"><span>{$iCountCommentFavourite} {$aLang.plugin.admin.users.profile.info.comments}</span></a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.reads}</div>
				<ul>
					<li><a href="#" class="link-border"><span>{$iCountBlogReads} {$aLang.plugin.admin.users.profile.info.blogs}</span></a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.has}</div>
				<ul>
					<li><a href="#" class="link-border"><span>{$iCountFriendsUser} {$aLang.plugin.admin.users.profile.info.friends}</span></a></li>
				</ul>
			</div>
		</div>

		{*
			Как голосовал пользователь
		*}
		<div class="user-info-block user-info-block-stats">
			<h2 class="user-info-heading">{$aLang.plugin.admin.users.profile.info.votings_title}</h2>

			{foreach from=array('topic', 'comment', 'blog', 'user') item=sType}
				<div class="user-info-block-stats-row">
					<div class="user-info-block-stats-header">
						<a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]={$sType}">{$aLang.plugin.admin.users.profile.info.votings[$sType]}</a>
					</div>
					<ul>
						{foreach from=array('plus', 'minus', 'abstain') item=sVoteDir}
							{if $aUserVotedStat[$sType][$sVoteDir]}
								<li>
									<a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]={$sType}&filter[dir]={$sVoteDir}">{$aUserVotedStat[$sType][$sVoteDir]}</a>
									{$aLang.plugin.admin.users.profile.info.votings_direction[$sVoteDir]}
								</li>
							{/if}
						{/foreach}
					</ul>
				</div>
			{/foreach}

		</div>

		{*
			Контакты
		*}
		{$aUserFieldContactValues = $oUser->getUserFieldValues(true,array('contact'))}
		{$aUserFieldSocialValues = $oUser->getUserFieldValues(true,array('social'))}

		{if $aUserFieldContactValues || $aUserFieldSocialValues}
			<div class="user-info-block user-info-block-contacts">
				<h2 class="user-info-heading">{$aLang.profile_contacts}</h2>
				
				<div class="clearfix">
					{if $aUserFieldContactValues}
						<ul class="user-contact-list">
							{foreach $aUserFieldContactValues as $oField}
								<li>
									<i class="icon-contact icon-contact-{$oField->getName()}" title="{$oField->getName()}"></i>
									{$oField->getValue(true,true)}
								</li>
							{/foreach}
						</ul>
					{/if}

					{if $aUserFieldSocialValues}
						<ul class="user-contact-list">
							{foreach $aUserFieldSocialValues as $oField}
								<li>
									<i class="icon-contact icon-contact-{$oField->getName()}" title="{$oField->getName()}"></i>
									{$oField->getValue(true,true)}
								</li>
							{/foreach}
						</ul>
					{/if}
				</div>
			</div>
		{/if}
	</div>
{/block}