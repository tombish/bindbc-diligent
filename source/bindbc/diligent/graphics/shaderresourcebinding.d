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

module bindbc.diligent.graphics.engine.shaderresourcebinding;

/// \file
/// Definition of the Diligent::IShaderResourceBinding interface and related data structures

import bindbc.diligent.primitives.object;
import bindbc.diligent.graphics.shader;
import bindbc.diligent.graphics.shaderresourcevariable;
import bindbc.diligent.graphics.resourcemapping;

struct IPipelineState;
struct IPipelineResourceSignature;

// {061F8774-9A09-48E8-8411-B5BD20560104}
static const INTERFACE_ID IID_ShaderResourceBinding =
    INTERFACE_ID(0x61f8774, 0x9a09, 0x48e8, [0x84, 0x11, 0xb5, 0xbd, 0x20, 0x56, 0x1, 0x4]);

/// Shader resource binding interface
struct IShaderResourceBindingMethods
{
    /// Returns a pointer to the pipeline resource signature object that
    /// defines the layout of this shader resource binding object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    IPipelineResourceSignature** GetPipelineResourceSignature(IShaderResourceBinding*);

    /// Binds SRB resources using the resource mapping

    /// \param [in] ShaderStages - Flags that specify shader stages, for which resources will be bound.
    ///                            Any combination of Diligent::SHADER_TYPE may be used.
    /// \param [in] pResMapping  - Shader resource mapping where required resources will be looked up.
    /// \param [in] Flags        - Additional flags. See Diligent::BIND_SHADER_RESOURCES_FLAGS.
    void* BindResources(IShaderResourceBinding*,
                                       SHADER_TYPE                 ShaderStages,
                                       IResourceMapping*           pResMapping,
                                       BIND_SHADER_RESOURCES_FLAGS Flags);

    /// Checks currently bound resources, see remarks.

    /// \param [in] ShaderStages - Flags that specify shader stages, for which to check resources.
    ///                            Any combination of Diligent::SHADER_TYPE may be used.
    /// \param [in] pResMapping  - Optional shader resource mapping where resources will be looked up.
    ///                            May be null.
    /// \param [in] Flags        - Additional flags, see remarks.
    ///
    /// \return     Variable type flags that did not pass the checks and thus may need to be updated.
    ///
    /// \remarks    This method may be used to perform various checks of the currently bound resources:
    ///
    ///             - BIND_SHADER_RESOURCES_UPDATE_MUTABLE and BIND_SHADER_RESOURCES_UPDATE_DYNAMIC flags
    ///               define which variable types to examine. Note that BIND_SHADER_RESOURCES_UPDATE_STATIC
    ///               has no effect as static resources are accessed through the PSO.
    ///
    ///             - If BIND_SHADER_RESOURCES_KEEP_EXISTING flag is not set and pResMapping is not null,
    ///               the method will compare currently bound resources with the ones in the resource mapping.
    ///               If any mismatch is found, the method will return the types of the variables that
    ///               contain mismatching resources.
    ///               Note that the situation when non-null object is bound to the variable, but the resource
    ///               mapping does not contain an object corresponding to the variable name, does not count as
    ///               mismatch.
    ///
    ///             - If BIND_SHADER_RESOURCES_VERIFY_ALL_RESOLVED flag is set, the method will check that
    ///               all resources of the specified variable types are bound and return the types of the variables
    ///               that are not bound.
    SHADER_RESOURCE_VARIABLE_TYPE_FLAGS* CheckResources(
                                        IShaderResourceBinding*,
                                        SHADER_TYPE                 ShaderStages,
                                        IResourceMapping*           pResMapping,
                                        BIND_SHADER_RESOURCES_FLAGS Flags);

    /// Returns the variable by its name.

    /// \param [in] ShaderType - Type of the shader to look up the variable.
    ///                          Must be one of Diligent::SHADER_TYPE.
    /// \param [in] Name       - Variable name.
    ///
    /// \note  This operation may potentially be expensive. If the variable will be used often, it is
    ///        recommended to store and reuse the pointer as it never changes.
    IShaderResourceVariable** GetVariableByName(IShaderResourceBinding*,
                                                               SHADER_TYPE ShaderType,
                                                               const(char)* Name);

    /// Returns the total variable count for the specific shader stage.

    /// \param [in] ShaderType - Type of the shader.
    /// \remark The method only counts mutable and dynamic variables that can be accessed through
    ///         the Shader Resource Binding object. Static variables are accessed through the Shader
    ///         object.
    uint* GetVariableCount(IShaderResourceBinding*, SHADER_TYPE ShaderType);

    /// Returns the variable by its index.

    /// \param [in] ShaderType - Type of the shader to look up the variable.
    ///                          Must be one of Diligent::SHADER_TYPE.
    /// \param [in] Index      - Variable index. The index must be between 0 and the total number
    ///                          of variables in this shader stage as returned by
    ///                          IShaderResourceBinding::GetVariableCount().
    /// \remark Only mutable and dynamic variables can be accessed through this method.
    ///         Static variables are accessed through the Shader object.
    ///
    /// \note   This operation may potentially be expensive. If the variable will be used often, it is
    ///         recommended to store and reuse the pointer as it never changes.
    IShaderResourceVariable** GetVariableByIndex(IShaderResourceBinding*,
                                                                SHADER_TYPE ShaderType,
                                                                uint Index);

    /// Returns true if static resources have been initialized in this SRB.
    bool* StaticResourcesInitialized(IShaderResourceBinding*);
}

struct IShaderResourceBindingVtbl { IShaderResourceBindingMethods ShaderResourceBinding; }
struct IShaderResourceBinding { IShaderResourceBindingVtbl* pVtbl; }

//#    define IShaderResourceBinding_GetPipelineResourceSignature(This) CALL_IFACE_METHOD(ShaderResourceBinding, GetPipelineResourceSignature, This)
//#    define IShaderResourceBinding_BindResources(This, ...)           CALL_IFACE_METHOD(ShaderResourceBinding, BindResources,                This, __VA_ARGS__)
//#    define IShaderResourceBinding_CheckResources(This, ...)          CALL_IFACE_METHOD(ShaderResourceBinding, CheckResources,               This, __VA_ARGS__)
//#    define IShaderResourceBinding_GetVariableByName(This, ...)       CALL_IFACE_METHOD(ShaderResourceBinding, GetVariableByName,            This, __VA_ARGS__)
//#    define IShaderResourceBinding_GetVariableCount(This, ...)        CALL_IFACE_METHOD(ShaderResourceBinding, GetVariableCount,             This, __VA_ARGS__)
//#    define IShaderResourceBinding_GetVariableByIndex(This, ...)      CALL_IFACE_METHOD(ShaderResourceBinding, GetVariableByIndex,           This, __VA_ARGS__)
//#    define IShaderResourceBinding_StaticResourcesInitialized(This)   CALL_IFACE_METHOD(ShaderResourceBinding, StaticResourcesInitialized,   This)

IPipelineResourceSignature** IShaderResourceBinding_GetPipelineResourceSignature(IShaderResourceBinding* binding) {
    return binding.pVtbl.ShaderResourceBinding.GetPipelineResourceSignature(binding);
}

void* IShaderResourceBinding_BindResources(IShaderResourceBinding* binding,
                                       SHADER_TYPE                 shaderStages,
                                       IResourceMapping*           pResMapping,
                                       BIND_SHADER_RESOURCES_FLAGS flags) {
    return binding.pVtbl.ShaderResourceBinding.BindResources(binding, shaderStages, pResMapping, flags);
}

SHADER_RESOURCE_VARIABLE_TYPE_FLAGS* CIShaderResourceBinding_CheckResources(IShaderResourceBinding* binding,
                                        SHADER_TYPE                 shaderStages,
                                        IResourceMapping*           pResMapping,
                                        BIND_SHADER_RESOURCES_FLAGS flags) {
    return binding.pVtbl.ShaderResourceBinding.CheckResources(binding, shaderStages, pResMapping, flags);
}

IShaderResourceVariable** IShaderResourceBinding_GetVariableByName(IShaderResourceBinding* binding, SHADER_TYPE shaderType, const(char)* name) {
    return binding.pVtbl.ShaderResourceBinding.GetVariableByName(binding, shaderType, name);
}

uint* IShaderResourceBinding_GetVariableCount(IShaderResourceBinding* binding, SHADER_TYPE shaderType) {
    return binding.pVtbl.ShaderResourceBinding.GetVariableCount(binding, shaderType);
}

IShaderResourceVariable** IShaderResourceBinding_GetVariableByIndex(IShaderResourceBinding* binding, SHADER_TYPE shaderType, uint index) {
    return binding.pVtbl.ShaderResourceBinding.GetVariableByIndex(binding, shaderType, index);
}

bool* IShaderResourceBinding_StaticResourcesInitialized(IShaderResourceBinding* binding) {
    return binding.pVtbl.ShaderResourceBinding.StaticResourcesInitialized(binding);
}
