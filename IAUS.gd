class MyPotentialActionsSorter:
		static func sort(a, b):
			return a.score >= b.score

class InfiniteAxisUtilitySystem:
    func _init():
        self.actions = []
        self.potential_actions = []
        self.RCM = ResponseCurveManager()
        self.axis_manager = AxisManager(self.RCM)

    func add_action(action_var):
        self.actions.append(action_var)

    func evaluate_actions(data=null):
        self.potential_actions = []

        for action in self.actions:
            if action.check_validity(data):
                potential_actions_of_action = action.get_potential_action_list()
                self.potential_actions.extend(potential_actions_of_action)
					
        self.potential_actions.sort_custom(MyPotentialActionsSorter, "sort")

    func get_best_action(data=null):
        id_best_action = 0

        while (id_best_action < len(self.potential_actions) and not self.potential_actions[id_best_action].action.check_validity(data)):
            id_best_action = id_best_action + 1

        if id_best_action < len(self.potential_actions):
            if self.potential_actions[id_best_action].action.action_handle != null:
                return [self.potential_actions[id_best_action].action.action_handle, self.potential_actions[id_best_action].target]
            else:
                return [self.potential_actions[id_best_action].action, self.potential_actions[id_best_action].target]

        return null

    # TODO:
    func get_random_best_relative_to_score(percent, data=null):
        return self.get_best_action(data)

    # TODO:
    func get_random_best_relative_to_order(percent, data=null):
        return self.get_best_action(data)


class Action:
    func _init(axis_manager, name, weight, action_handle=null):
        self.axis_manager = axis_manager
        self.axes = []
        self.weight = weight
        self.name = name
        self.action_handle = action_handle
        self.generate_targets = null

    func add_axis_struct(axis_struct_var):
        self.axes.append(axis_struct_var)

    func get_potential_action_list():
        potential_action_list = []
        if self.generate_targets != null:
            for target in self.generate_targets():
                potential_action_list.append(PotentialActionStruct(self, target, self.weight * self.score(target)))
        else:
            potential_action_list.append(PotentialActionStruct(self, null, self.weight * self.score()))
        return potential_action_list

    func check_validity(data=null):
        return self.action_handle is null or self.action_handle.check_validity(data)

    func score(target=null):
        self.axis_manager.clear()

        score = 1.0

        for axis_struct_var in self.axes:
            score = score * self.axis_manager.score(axis_struct_var.id, axis_struct_var.response_curve, target)
            if score < 0.00001:
                return 0.0

        return pow(score, 1 / len(self.axes))


class PotentialActionStruct:
    func _init(action, target, score):
        self.action = action
        self.target = target
        self.score = score

    func is_valid():
        return self.action != null


class AxisStruct:
    func _init(id, response_curve, axis_manager=null):
        if axis_manager != null:
            self.id = axis_manager.axis_name_to_id(id)  # ID contains the Name
        else:
            self.id = id
        self.response_curve = response_curve


class Axis:
    var _nb_axis = 0
    var _axes_name = []

    func _init(memory, name):
        self.name = name
        if name in Axis._axes_name:
            return
        else:
            self.memory = memory
            self.id = Axis._nb_axis
            Axis._nb_axis = Axis._nb_axis + 1

            self.score = 0.0
            self.need_to_update = True
            self.bad_design = False
            self.score_function = null

    func clear():
        self.need_to_update = True

    func get_score(target=null):
        if self.need_to_update:
            assert not self.bad_design
            self.bad_design = True

            self.score = Math.clamp(self._compute_score(target) if self.score_function is null else self.score_function(target), 0.0, 1.0)

            self.bad_design = False
            self.need_to_update = False

        return self.score

    # protected, overridable function
    func _compute_score(target=null):
        return 0.0


class AxisManager:
    func _init(response_curve_manager):
        self.axes = {}
        self.RCM = response_curve_manager

    func add_axis(axis_var):
        if self.axis_name_to_id(axis_var.name) < 0:
            self.axes[axis_var.id] = axis_var

    func axis_name_to_id(name):
        for axis in list(self.axes.values()):
            if axis.name == name:
                return axis.id
        return -1

    func score(axis_id, response_curve, target=null):
        axis = self.axes[axis_id]
        if axis != null:
            return self.RCM.apply(response_curve, axis.get_score(target))

    func clear():
        for axis in list(self.axes.values()):
            axis.clear()


class ResponseCurve:
    func _init(type, slope, exponent, x_shift, y_shift):
        self.types = ['linear', 'polynomial', 'logistic', 'logit']
        if not (type in self.types):
            print('Value ' + type + ' not a valid response curve.')
        self.type = type
        self.slope = slope
        self.exponent = exponent
        self.x_shift = x_shift
        self.y_shift = y_shift

        if type == 'logistic':
            self.max = 1.0 / (1.0 + pow(2.718 * 100 * slope, x_shift - 0.5))
            self.min = 1.0 / (1.0 + pow(2.718 * 100 * slope, x_shift + 0.5))


class ResponseCurveManager:
	static func linear(response_curve, score):
		return response_curve.slope * (score - response_curve.x_shift) + response_curve.y_shift
		
	static func polynomial(response_curve, score):
		return response_curve.slope * pow(score - response_curve.x_shift, response_curve.exponent) + response_curve.y_shift
	
	static func logistic(response_curve, score):
		return response_curve.exponent * ((1.0 / (1.0 + pow(271.8 * response_curve.slope, 0.5 + response_curve.x_shift - score))) - response_curve.min) / (response_curve.max - response_curve.min) + response_curve.y_shift
	
	static func logit(response_curve, score):
		return response_curve.slope * log((score - response_curve.x_shift) / (1.0 - score + response_curve.x_shift)) / 5.0 + 0.5 + response_curve.y_shift

	func _init():
		self.response_curves = {}
		self.response_curves["linear"] = funcref(self, "linear")
		self.response_curves["polynomial"] = funcref(self, "polynomial")
		self.response_curves["logistic"] = funcref(self, "logistic")
		self.response_curves["logit"] = funcref(self, "logit")

	func apply(response_curve, score):
		return self.response_curves[response_curve.type].call_func(response_curve, score)

