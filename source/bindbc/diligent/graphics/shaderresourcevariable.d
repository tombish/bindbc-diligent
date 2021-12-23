/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.shaderresourcevariable;

/// \file
/// Definition of the Diligent::IShaderResourceVariable interface and related data structures

import bindbc.diligent.primitives.object;
import bindbc.diligent.graphics.deviceobject;
import bindbc.diligent.graphics.shader;

// {0D57DF3F-977D-4C8F-B64C-6675814BC80C}
static const INTERFACE_ID IID_ShaderResourceVariable =
    INTERFACE_ID(0xd57df3f, 0x977d, 0x4c8f, [0xb6, 0x4c, 0x66, 0x75, 0x81, 0x4b, 0xc8, 0xc]);

/// Describes the type of the shader resource variable
enum SHADER_RESOURCE_VARIABLE_TYPE : ubyte
{
    /// Shader resource bound to the variable is the same for all SRB instances.
    /// It must be set *once* directly through Pipeline State object.
    SHADER_RESOURCE_VARIABLE_TYPE_STATIC = 0,

    /// Shader resource bound to the variable is specific to the shader resource binding
    /// instance (see Diligent::IShaderResourceBinding). It must be set *once* through
    /// Diligent::IShaderResourceBinding interface. It cannot be set through Diligent::IPipelineState
    /// interface and cannot be change once bound.
    SHADER_RESOURCE_VARIABLE_TYPE_MUTABLE,

    /// Shader variable binding is dynamic. It can be set multiple times for every instance of shader resource
    /// binding (see Diligent::IShaderResourceBinding). It cannot be set through Diligent::IPipelineState interface.
    SHADER_RESOURCE_VARIABLE_TYPE_DYNAMIC,

    /// Total number of shader variable types
    SHADER_RESOURCE_VARIABLE_TYPE_NUM_TYPES
}

/// Shader resource variable type flags
enum SHADER_RESOURCE_VARIABLE_TYPE_FLAGS : uint
{
    /// No flags
    SHADER_RESOURCE_VARIABLE_TYPE_FLAG_NONE    = 0x00,

    /// Static variable type flag
    SHADER_RESOURCE_VARIABLE_TYPE_FLAG_STATIC  = (0x01 << SHADER_RESOURCE_VARIABLE_TYPE.SHADER_RESOURCE_VARIABLE_TYPE_STATIC),

    /// Mutable variable type flag
    SHADER_RESOURCE_VARIABLE_TYPE_FLAG_MUTABLE = (0x01 << SHADER_RESOURCE_VARIABLE_TYPE.SHADER_RESOURCE_VARIABLE_TYPE_MUTABLE),

    /// Dynamic variable type flag
    SHADER_RESOURCE_VARIABLE_TYPE_FLAG_DYNAMIC = (0x01 << SHADER_RESOURCE_VARIABLE_TYPE.SHADER_RESOURCE_VARIABLE_TYPE_DYNAMIC),

    /// Mutable and dynamic variable type flags
    SHADER_RESOURCE_VARIABLE_TYPE_FLAG_MUT_DYN = 
        SHADER_RESOURCE_VARIABLE_TYPE_FLAG_MUTABLE | 
        SHADER_RESOURCE_VARIABLE_TYPE_FLAG_DYNAMIC,

    /// All variable type flags
    SHADER_RESOURCE_VARIABLE_TYPE_FLAG_ALL = 
        SHADER_RESOURCE_VARIABLE_TYPE_FLAG_STATIC | 
        SHADER_RESOURCE_VARIABLE_TYPE_FLAG_MUTABLE | 
        SHADER_RESOURCE_VARIABLE_TYPE_FLAG_DYNAMIC
}

/// Shader resource binding flags
enum BIND_SHADER_RESOURCES_FLAGS : uint
{
    /// Indicates that static shader variable bindings are to be updated.
    BIND_SHADER_RESOURCES_UPDATE_STATIC = SHADER_RESOURCE_VARIABLE_TYPE_FLAGS.SHADER_RESOURCE_VARIABLE_TYPE_FLAG_STATIC,

    /// Indicates that mutable shader variable bindings are to be updated.
    BIND_SHADER_RESOURCES_UPDATE_MUTABLE = SHADER_RESOURCE_VARIABLE_TYPE_FLAGS.SHADER_RESOURCE_VARIABLE_TYPE_FLAG_MUTABLE,

    /// Indicates that dynamic shader variable bindings are to be updated.
    BIND_SHADER_RESOURCES_UPDATE_DYNAMIC = SHADER_RESOURCE_VARIABLE_TYPE_FLAGS.SHADER_RESOURCE_VARIABLE_TYPE_FLAG_DYNAMIC,

    /// Indicates that all shader variable types (static, mutable and dynamic) are to be updated.
    /// \note If none of BIND_SHADER_RESOURCES_UPDATE_STATIC, BIND_SHADER_RESOURCES_UPDATE_MUTABLE,
    ///       and BIND_SHADER_RESOURCES_UPDATE_DYNAMIC flags are set, all variable types are updated
    ///       as if BIND_SHADER_RESOURCES_UPDATE_ALL was specified.
    BIND_SHADER_RESOURCES_UPDATE_ALL = SHADER_RESOURCE_VARIABLE_TYPE_FLAGS.SHADER_RESOURCE_VARIABLE_TYPE_FLAG_ALL,

    /// If this flag is specified, all existing bindings will be preserved and
    /// only unresolved ones will be updated.
    /// If this flag is not specified, every shader variable will be
    /// updated if the mapping contains corresponding resource.
    BIND_SHADER_RESOURCES_KEEP_EXISTING = 0x08,

    /// If this flag is specified, all shader bindings are expected
    /// to be resolved after the call. If this is not the case, debug message
    /// will be displayed.
    /// \note Only these variables are verified that are being updated by setting
    ///       BIND_SHADER_RESOURCES_UPDATE_STATIC, BIND_SHADER_RESOURCES_UPDATE_MUTABLE, and
    ///       BIND_SHADER_RESOURCES_UPDATE_DYNAMIC flags.
    BIND_SHADER_RESOURCES_VERIFY_ALL_RESOLVED = 0x10
}

/// Shader resource variable
struct IShaderResourceVariableMethods
{
    /// Binds resource to the variable

    /// \remark The method performs run-time correctness checks.
    ///         For instance, shader resource view cannot
    ///         be assigned to a constant buffer variable.
    void* Set(IShaderResourceVariable*, IDeviceObject* pObject);

    /// Binds resource array to the variable

    /// \param [in] ppObjects    - pointer to the array of objects.
    /// \param [in] FirstElement - first array element to set.
    /// \param [in] NumElements  - number of objects in ppObjects array.
    ///
    /// \remark The method performs run-time correctness checks.
    ///         For instance, shader resource view cannot
    ///         be assigned to a constant buffer variable.
    void* SetArray(IShaderResourceVariable*,
                                  const(IDeviceObject)** ppObjects,
                                  uint                FirstElement,
                                  uint                NumElements);

    /// Binds the specified constant buffer range to the variable

    /// \param [in] pObject    - pointer to the buffer object.
    /// \param [in] Offset     - offset, in bytes, to the start of the buffer range to bind.
    /// \param [in] Size       - size, in bytes, of the buffer range to bind.
    /// \param [in] ArrayIndex - for array variables, index of the array element.
    ///
    /// \remarks This method is only allowed for constant buffers. If dynamic offset is further set
    ///          by SetBufferOffset() method, it is added to the base offset set by this method.
    ///
    ///          The method resets dynamic offset previously set for this variable to zero.
    ///
    /// \warning The Offset must be an integer multiple of ConstantBufferOffsetAlignment member
    ///          specified by the device limits (see Diligent::DeviceLimits).
    void* SetBufferRange(IShaderResourceVariable*,
                                        IDeviceObject* pObject,
                                        uint         Offset,
                                        uint         Size,
                                        uint         ArrayIndex = 0);

    /// Sets the constant or structured buffer dynamic offset

    /// \param [in] Offset     - additional offset, in bytes, that is added to the base offset (see remarks).
    /// \param [in] ArrayIndex - for array variables, index of the array element.
    ///
    /// \remarks This method is only allowed for constant or structured buffer variables that
    ///          were not created with SHADER_VARIABLE_FLAG_NO_DYNAMIC_BUFFERS or
    ///          PIPELINE_RESOURCE_FLAG_NO_DYNAMIC_BUFFERS flags. The method is also not
    ///          allowed for static resource variables.
    ///
    /// \warning The Offset must be an integer multiple of ConstantBufferOffsetAlignment member
    ///          when setting the offset for a constant buffer, or StructuredBufferOffsetAlignment when
    ///          setting the offset for a structured buffer, as specified by device limits
    ///          (see Diligent::DeviceLimits).
    ///
    ///          For constant buffers, the offset is added to the offset that was previously set
    ///          by SetBufferRange() method (if any). For structured buffers, the offset is added
    ///          to the base offset specified by the buffer view.
    ///
    ///          Changing the buffer offset does not require committing the SRB.
    ///          From the engine point of view, buffers with dynamic offsets are treated similar to dynamic
    ///          buffers, and thus affected by DRAW_FLAG_DYNAMIC_RESOURCE_BUFFERS_INTACT flag.
    void* SetBufferOffset(IShaderResourceVariable*,
                                         uint Offset,
                                         uint ArrayIndex = 0);

    /// Returns the shader resource variable type
    SHADER_RESOURCE_VARIABLE_TYPE* GetType(IShaderResourceVariable*);

    /// Returns shader resource description. See Diligent::ShaderResourceDesc.
    void* GetResourceDesc(IShaderResourceVariable*, ShaderResourceDesc* ResourceDesc);

    /// Returns the variable index that can be used to access the variable.
    uint* GetIndex(IShaderResourceVariable*);

    /// Returns a pointer to the resource that is bound to this variable.

    /// \param [in] ArrayIndex - Resource array index. Must be 0 for
    ///                          non-array variables.
    IDeviceObject** Get(IShaderResourceVariable*, uint ArrayIndex = 0) ;
}

struct IShaderResourceVariableVtbl { IShaderResourceVariableMethods ShaderResourceVariable; }
struct IShaderResourceVariable { IShaderResourceVariableVtbl* pVtbl; }

void* IShaderResourceVariable_Set(IShaderResourceVariable* resVariable, IDeviceObject* pObject) {
    return resVariable.pVtbl.ShaderResourceVariable.Set(resVariable, pObject);
}

void* IShaderResourceVariable_SetArray(IShaderResourceVariable* resVariable,
                                  const(IDeviceObject)** ppObjects,
                                  uint                FirstElement,
                                  uint                NumElements) {
    return resVariable.pVtbl.ShaderResourceVariable.SetArray(resVariable, ppObjects, FirstElement, NumElements);
}

void* IShaderResourceVariable_SetBufferRange(IShaderResourceVariable* resVariable,
                                        IDeviceObject* pObject,
                                        uint         Offset,
                                        uint         Size,
                                        uint         ArrayIndex = 0) {
    return resVariable.pVtbl.ShaderResourceVariable.SetBufferRange(resVariable, pObject, Offset, Size, ArrayIndex);
}

void* IShaderResourceVariable_SetBufferOffset(IShaderResourceVariable* resVariable,
                                         uint Offset,
                                         uint ArrayIndex = 0) {
    return resVariable.pVtbl.ShaderResourceVariable.SetBufferOffset(resVariable, Offset, ArrayIndex);
}

SHADER_RESOURCE_VARIABLE_TYPE* IShaderResourceVariable_GetType(IShaderResourceVariable* resVariable) {
    return resVariable.pVtbl.ShaderResourceVariable.GetType(resVariable);

}

void* IShaderResourceVariable_GetResourceDesc(IShaderResourceVariable* resVariable, ShaderResourceDesc* ResourceDesc) {
    return resVariable.pVtbl.ShaderResourceVariable.GetResourceDesc(resVariable, ResourceDesc);
}

uint* IShaderResourceVariable_GetIndex(IShaderResourceVariable* resVariable) {
    return resVariable.pVtbl.ShaderResourceVariable.GetIndex(resVariable);
}

IDeviceObject** IShaderResourceVariable_Get(IShaderResourceVariable* resVariable, uint ArrayIndex = 0) {
    return resVariable.pVtbl.ShaderResourceVariable.Get(resVariable, ArrayIndex);
}
