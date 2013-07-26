<?php
/**
 * LiveStreet CMS
 * Copyright © 2013 OOO "ЛС-СОФТ"
 * 
 * ------------------------------------------------------
 * 
 * Official site: www.livestreetcms.com
 * Contact e-mail: office@livestreetcms.com
 * 
 * GNU General Public License, version 2:
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 * 
 * ------------------------------------------------------
 * 
 * @link http://www.livestreetcms.com
 * @copyright 2013 OOO "ЛС-СОФТ"
 * @author PSNet <light.feel@gmail.com>
 * 
 */

/*
 *	Работа с настройками плагинов
 */

class PluginAdmin_ActionAdmin_EventSettings extends Event {
	
	/*
	 *	Показать настройки плагина
	 */
	public function EventShow () {
		// Корректно ли имя конфига
		if (!$sConfigName = $this -> getParam (1) or !is_string ($sConfigName)) {
			$this -> Message_AddError ($this -> Lang_Get ('plugin.admin.Errors.Wrong_Config_Name'), $this -> Lang_Get ('error'));
			return false;
		}
		
		if (!$this -> PluginAdmin_Settings_CheckPluginNameIsActive ($sConfigName)) {
			$this -> Message_AddError ($this -> Lang_Get ('plugin.admin.Errors.Plugin_Need_To_Be_Activated'), $this -> Lang_Get ('error'));
			return false;
		}

		$aSettingsAll = $this -> PluginAdmin_Settings_GetConfigSettings ($sConfigName);
		
		$this -> Viewer_Assign ('aSettingsAll', $aSettingsAll);
		$this -> Viewer_Assign ('sConfigName', $sConfigName);
		$this -> Lang_AddLangJs (array ('plugin.admin.Errors.Some_Fields_Are_Incorrect'));
	}

	
	/*
	 *	Сохранить настройки
	 */
	public function EventSaveConfig () {
		if ($bAjax = isAjaxRequest ()) {
			$this -> Viewer_SetResponseAjax ('json');
		}
		
		$this -> Security_ValidateSendForm ();

		if (isPost ('submit_save_settings')) {
			if ($this -> SaveSettings () and !$bAjax) {
				$this -> Message_AddNotice ('Ok', '', true);
			}
			if ($bAjax) {
				$this -> Viewer_AssignAjax ('aParamErrors', $this -> Message_GetParamsErrors ());
			}
		}
		
		if (!$bAjax) {
			return $this -> RedirectToReferer ();
		}
	}
	
	
	protected function SaveSettings () {
		// Корректно ли имя конфига
		if (!$sConfigName = $this -> getParam (1) or !is_string ($sConfigName)) {
			$this -> Message_AddError ($this -> Lang_Get ('plugin.admin.Errors.Wrong_Config_Name'), $this -> Lang_Get ('error'));
			return false;
		}
		
		if ($sConfigName != ModuleStorage::DEFAULT_KEY_NAME and !$this -> PluginAdmin_Settings_CheckPluginNameIsActive ($sConfigName)) {
			$this -> Message_AddError ($this -> Lang_Get ('plugin.admin.Errors.Plugin_Need_To_Be_Activated'), $this -> Lang_Get ('error'));
			return false;
		}

		// Получение всех параметров, их валидация и сверка с описанием структуры и запись в отдельную инстанцию конфига
		if ($this -> PluginAdmin_Settings_ParsePOSTDataIntoSeparateConfigInstance ($sConfigName)) {
			// Сохранить все настройки плагина в БД
			$this -> PluginAdmin_Settings_SaveConfigByKey ($sConfigName);
			return true;
		}
		return false;
	}
	
	
	/*
	 *	Получение настроек ядра по группе
	 */
	protected function ShowSystemSettings ($aKeysToShow = array (), $aKeysToExcludeFromList = array ()) {
		$sConfigName = ModuleStorage::DEFAULT_KEY_NAME;
		$aSettingsAll = $this -> PluginAdmin_Settings_GetConfigSettings ($sConfigName, $aKeysToShow, $aKeysToExcludeFromList);

		$this -> Viewer_Assign ('aSettingsAll', $aSettingsAll);
		$this -> Viewer_Assign ('sConfigName', $sConfigName);
		$this -> Viewer_Assign ('aKeysToShow', $aKeysToShow);
	}
	
	
	protected function GetGroupsListAndShowSettings ($sGroupName) {
		return $this -> ShowSystemSettings (
			$this -> aCoreSettingsGroups [$sGroupName]['allowed'],
			$this -> aCoreSettingsGroups [$sGroupName]['exclude']
		);
	}
	
	
	public function __call ($sName, $aArgs) {
		// если это вызов для показа системных настроек ядра
		if (strpos ($sName, $this -> sCallbackMethodToShowSystemSettings) !== false) {
			// пробуем получить имя группы настроек как оно должно быть записано в конфиге
			$sGroupName = strtolower (str_replace ($this -> sCallbackMethodToShowSystemSettings, '', $sName));
			// если такая группа настроек существует
			if (isset ($this -> aCoreSettingsGroups [$sGroupName])) {
				return $this -> GetGroupsListAndShowSettings ($sGroupName);
			}
			throw new Exception ('Admin: error: there is no settings group name as "' . $sGroupName . '"');			// this msg will be never shown
		}
		return parent::__call ($sName, $aArgs);
	}
	
	
	/*
	 *	Работа с шаблонами
	 */
	public function EventChangeSkin () {
		$this -> SetTemplateAction ('skin/list');
		
		$aSkinsData = $this -> PluginAdmin_Skin_GetSkinList (array(
			'separate_current_skin' => true,
			'delete_current_skin_from_list' => true
		));
		$aSkinList = $aSkinsData['skins'];
		$oCurrentSkin = $aSkinsData['current'];
		
		if ($sAction = $this -> getParam (1) and in_array ($sAction, array ('use', 'preview', 'turnoffpreview'))) {
			if ($sSkinName = $this -> getParam (2) and isset ($aSkinList [$sSkinName])) {
				$this -> Security_ValidateSendForm ();
				
				$sMethodName = ucfirst ($sAction) . 'Skin';
				$this -> {$sMethodName} ($sSkinName);
				
				return $this -> RedirectToReferer ();
			} else {
				$this -> Message_AddError ('Incorrect skin name');
			}
		}
		$this -> Viewer_Assign ('aSkins', $aSkinList);
		$this -> Viewer_Assign ('oCurrentSkin', $oCurrentSkin);
	}
	
	
	private function UseSkin ($sSkinName) {
		$this -> PluginAdmin_Skin_ChangeSkin ($sSkinName);
		$this -> Message_AddNotice ($this -> Lang ('notices.template_changed'), '', true);
	}
	
	
	private function PreviewSkin ($sSkinName) {
		$this -> PluginAdmin_Skin_PreviewSkin ($sSkinName);
		$this -> Message_AddNotice ($this -> Lang ('notices.template_preview_set'), '', true);
	}
	
	
	private function TurnoffpreviewSkin ($sSkinName) {
		$this -> PluginAdmin_Skin_TurnOffPreviewSkin ();
		$this -> Message_AddNotice ($this -> Lang ('notices.template_preview_turned_off'), '', true);
	}
	
}

?>