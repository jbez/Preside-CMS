/**
 * Service to provide logic around recipient types
 *
 * @singleton      true
 * @presideservice true
 * @autodoc        true
 *
 */
component displayName="Email Recipient Type Service" {

// CONSTRUCTOR
	/**
	 * @configuredRecipientTypes.inject coldbox:setting:email.recipientTypes
	 *
	 */
	public any function init(
		  required struct configuredRecipientTypes
	) {
		_setConfiguredRecipientTypes( arguments.configuredRecipientTypes );

		return this;
	}

// PUBLIC API
	/**
	 * Returns an array of recipient types with translated titles and descriptions,
	 * ordered by title.
	 *
	 * @autodoc true
	 */
	public array function listRecipientTypes() {
		var types           = [];
		var configuredTypes = _getConfiguredRecipientTypes();

		for( var typeId in configuredTypes ){
			types.append({
				  id          = typeId
				, title       = $translateResource( uri="email.recipienttype.#typeId#:title"      , defaultValue=typeId )
				, description = $translateResource( uri="email.recipienttype.#typeId#:description", defaultValue=""     )
			});
		}

		types.sort( function( a, b ){
			return a.title > b.title ? 1 : -1;
		} );

		return types;
	}

	/**
	 * Returns whether or not the passed recipient type exists.
	 *
	 * @autodoc            true
	 * @recipientType.hint ID of the type to check
	 *
	 */
	public boolean function recipientTypeExists( required string recipientType ) {
		return _getConfiguredRecipientTypes().keyExists( arguments.recipientType );
	}

	/**
	 * Prepares email parameters (variables for substituting in subject + body)
	 * for the given recipient type and provided args (e.g. could contain user id)
	 *
	 * @autodoc            true
	 * @recipientType.hint The ID of the recipient type who's params we are to prepare
	 * @args.hint          Structure of variables sent to the sendEmail() method, should contain enough data to inform the method how to prepare the params. e.g. { userId=idofUserToSendEmailTo }.
	 */
	public struct function prepareParameters(
		  required string recipientType
		,          struct args = {}
	) {
		var handlerAction = "email.recipientType.#recipientType#.prepareParameters";

		if ( recipientTypeExists( arguments.recipientType ) && $getColdbox().handlerExists( handlerAction ) ) {
			return $getColdbox().runEvent(
				  event          = handlerAction
				, eventArguments = { args=arguments.args }
				, private        = true
				, prePostExempt  = true
			);
		}

		return {};
	}

	/**
	 * Returns a struct of "preview" parameters that can be used to preview an
	 * email template.
	 *
	 * @autodoc            true
	 * @recipientType.hint The ID of the recipient type who's preview params we are to get
	 */
	public struct function getPreviewParameters( required string recipientType ) {
		var handlerAction = "email.recipientType.#recipientType#.getPreviewParameters";

		if ( recipientTypeExists( arguments.recipientType ) && $getColdbox().handlerExists( handlerAction ) ) {
			return $getColdbox().runEvent(
				  event          = handlerAction
				, private        = true
				, prePostExempt  = true
			);
		}

		return {};
	}

	/**
	 * Returns the to address for the given recipient type and message
	 * args.
	 *
	 * @autodoc            true
	 * @recipientType.hint The ID of the recipient type who's to address we are to get
	 * @args.hint          Structure of variables sent to the sendEmail() method, should contain enough data to inform the method how to get the address. e.g. { userId=idofUserToSendEmailTo }.
	 */
	public string function getToAddress(
		  required string recipientType
		,          struct args = {}
	) {
		var handlerAction = "email.recipientType.#recipientType#.getToAddress";

		if ( recipientTypeExists( arguments.recipientType ) && $getColdbox().handlerExists( handlerAction ) ) {
			return $getColdbox().runEvent(
				  event          = handlerAction
				, eventArguments = { args=arguments.args }
				, private        = true
				, prePostExempt  = true
			);
		}

		return "";
	}

// GETTERS AND SETTERS
	private any function _getConfiguredRecipientTypes() {
		return _configuredRecipientTypes;
	}
	private void function _setConfiguredRecipientTypes( required any configuredRecipientTypes ) {
		_configuredRecipientTypes = arguments.configuredRecipientTypes;
	}
}