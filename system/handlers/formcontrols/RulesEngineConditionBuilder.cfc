component {

	property name="expressionService" inject="rulesEngineExpressionService";

	private string function index( event, rc, prc, args={} ) {
		args.ruleContext = args.ruleContext ?: ( rc.context ?: "" );
		args.expressions = expressionService.listExpressions( args.ruleContext );

		event.include( "/js/admin/specific/rulesEngineConditionBuilder/"  )
		     .include( "/css/admin/specific/rulesEngineConditionBuilder/" )
		     .includeData( { rulesEngineExpressions = { "#args.id#" = args.expressions } } );

		return renderView( view="/formControls/rulesEngineConditionBuilder/index", args=args );
	}

}