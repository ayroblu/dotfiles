; extends
(jsx_attribute) @jsx_attribute
(jsx_expression (_) @assignment.inner)
(jsx_attribute . (_) @assignment.inner) @assign.outer

(jsx_attribute (property_identifier) @assign_left.inner
                (jsx_expression (_) @assign_right.inner) @assign_right_outer) @assign_left.outer @assign_right.outer
